with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Streams;
use Ada.Streams;
with GNAT.Sockets;
use GNAT.Sockets;
with Buffer; use type Buffer.Byte;
with Buffer_Queues;
with Telnet.Workers;
with Shared_Buffers;

procedure Test_Server is
   Server_Address : Sock_Addr_Type;
   Client_Address : Sock_Addr_Type;
   Server_Socket : Socket_Type;
   Offset : Ada.Streams.Stream_Element_Offset;

   Worker : Telnet.Workers.Worker (
      Shared_Buffers.RX'Access,
      Shared_Buffers.TX'Access,
      True);

   task type Transmitter (
      Client_Socket : access Socket_Type;
      TX : access Buffer_Queues.Queue) is
      entry Connect;
   end Transmitter;

   task body Transmitter is
      Sent_Byte : Buffer.Byte;
      TX_Offset : Ada.Streams.Stream_Element_Offset;
      Response : Ada.Streams.Stream_Element_Array (1 .. 2);
   begin
      accept Connect;
      loop
         TX.Dequeue (Sent_Byte);
         Response (1) := Ada.Streams.Stream_Element (Sent_Byte);
         TX_Offset := 1;
         Send_Socket (Client_Socket.all, Response (1 .. 1), TX_Offset);
      end loop;
   end Transmitter;

   Transmitter_Task : Transmitter (
      Shared_Buffers.Terminal_Socket'Access,
      Shared_Buffers.TX'Access);

   task type Receiver (Client_Socket : access Socket_Type;
      RX : access Buffer_Queues.Queue) is
      entry Connect;
      entry Disconnect;
   end Receiver;

   task body Receiver is
      Finished : Boolean;
      Stream_Data : Ada.Streams.Stream_Element_Array (1 .. 1024) := (others => 0);
   begin
      accept Connect;
      Finished := False;
      while not Finished loop
         Receive_Socket (Client_Socket.all, Stream_Data, Offset);
         if Offset = Stream_Data'First then
            Finished := True;
         else
            for J in Stream_Data'First .. Offset loop
               RX.Enqueue (Buffer.Byte (Stream_Data (J)));
            end loop;
         end if;
      end loop;
      Close_Socket (Client_Socket.all);
      accept Disconnect;
   end Receiver;

   Receiver_Task : Receiver (Shared_Buffers.Terminal_Socket'Access,
      Shared_Buffers.RX'Access);

begin
   Server_Address.Addr := Inet_Addr ("127.0.0.1");
   Server_Address.Port := 17002;
   Create_Socket (Server_Socket);
   Set_Socket_Option (Server_Socket, Socket_Level, 
      (Reuse_Address, True));
   Bind_Socket (Server_Socket, Server_Address);
   Listen_Socket (Server_Socket);
   Accept_Socket (Server_Socket,
      Shared_Buffers.Terminal_Socket, Client_Address);
   Transmitter_Task.Connect;
   Receiver_Task.Connect;
   Receiver_Task.Disconnect;
   abort Transmitter_Task;
   abort Worker;
   abort Receiver_Task;
    
end Test_Server; 
