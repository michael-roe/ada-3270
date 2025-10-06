with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Streams;
use Ada.Streams;
with GNAT.Sockets;
use GNAT.Sockets;

procedure Test_Server is
   Server_Address : Sock_Addr_Type;
   Client_Address : Sock_Addr_Type;
   Server_Socket : Socket_Type;
   Client_Socket : Socket_Type;
   Stream_Data : Ada.Streams.Stream_Element_Array (1 .. 1024);
   Offset : Ada.Streams.Stream_Element_Offset;
   Finished : Boolean;
begin
   Server_Address.Addr := Inet_Addr ("127.0.0.1");
   Server_Address.Port := 17002;
   Create_Socket (Server_Socket);
   Set_Socket_Option (Server_Socket, Socket_Level, 
      (Reuse_Address, True));
   Bind_Socket (Server_Socket, Server_Address);
   Listen_Socket (Server_Socket);
   Accept_Socket (Server_Socket, Client_Socket, Client_Address);
   Finished := False;
   while not Finished loop
      Receive_Socket (Client_Socket, Stream_Data, Offset);
      if Offset = Stream_Data'First then
        Finished := True;
      else
        Send_Socket (Client_Socket,
           Stream_Data (Stream_Data'First .. Offset), Offset);
      end if;
   end loop;
   Close_Socket (Client_Socket);
   
end Test_Server; 
