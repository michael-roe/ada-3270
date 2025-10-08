with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Streams;
use Ada.Streams;
with GNAT.Sockets;
use GNAT.Sockets;
with Buffer; use type Buffer.Byte;
with Buffer_Queues;
with Telnet.Workers;

procedure Test_Server is
   Server_Address : Sock_Addr_Type;
   Client_Address : Sock_Addr_Type;
   Server_Socket : Socket_Type;
   Client_Socket : Socket_Type;
   Stream_Data : Ada.Streams.Stream_Element_Array (1 .. 1024);
   Offset : Ada.Streams.Stream_Element_Offset;
   Finished : Boolean;
   RX : aliased Buffer_Queues.Queue;
   TX : aliased Buffer_Queues.Queue;
   Worker : Telnet.Workers.Worker (RX'Access, TX'Access, True);
   task Responder is
      entry Connect;
   end Responder;
   task body Responder is
      Sent_Byte : Buffer.Byte;
      TX_Offset : Ada.Streams.Stream_Element_Offset;
      Response : Ada.Streams.Stream_Element_Array (1 .. 2);
   begin
      accept Connect;
      loop
         TX.Dequeue (Sent_Byte);
         Response (1) := Ada.Streams.Stream_Element (Sent_Byte);
         TX_Offset := 1;
         Send_Socket (Client_Socket, Response (1 .. 1), TX_Offset);
      end loop;
   end Responder;
begin
   Server_Address.Addr := Inet_Addr ("127.0.0.1");
   Server_Address.Port := 17002;
   Create_Socket (Server_Socket);
   Set_Socket_Option (Server_Socket, Socket_Level, 
      (Reuse_Address, True));
   Bind_Socket (Server_Socket, Server_Address);
   Listen_Socket (Server_Socket);
   Accept_Socket (Server_Socket, Client_Socket, Client_Address);
   Responder.Connect;
   Finished := False;
   while not Finished loop
      Receive_Socket (Client_Socket, Stream_Data, Offset);
      if Offset = Stream_Data'First then
         Finished := True;
      else
         for J in Stream_Data'First .. Offset loop
            RX.Enqueue (Buffer.Byte (Stream_Data (J)));
         end loop;
      end if;
   end loop;
   Close_Socket (Client_Socket);
   abort Responder;
   abort Worker;
   
end Test_Server; 
