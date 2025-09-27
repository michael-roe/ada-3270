with Ada.Text_IO; use Ada.Text_IO;
with Buffer; use Buffer; use type Buffer.Byte;
with Buffer_Queues; use Buffer_Queues;

--
--  This is an example of how to use Buffer_Queues for communication between
--  tasks. The Consumer task waits on queue Q, dequeuing bytes and writing
--  them to stdout until it receives a 0, which denotes end of file.
--

procedure Buffer_Example is
   Q : Buffer_Queues.Queue;
   Byte_Sent : constant Buffer.Byte := 42;
   Finished : Boolean;
   task Consumer;
   task body Consumer is
      Byte_Received : Buffer.Byte;
   begin
      Finished := False;
      while not Finished loop
         Q.Dequeue (Byte_Received);
         if Byte_Received = 0 then
            New_Line (1);
            Put_Line ("Done");
            Finished := True;
         else
            Put (Character'Val (Byte_Received));
         end if;
      end loop;
   end Consumer;
begin

   Q.Clear;
   for J in 1 .. 3 loop
      Q.Enqueue (Byte_Sent);
   end loop;
   Q.Enqueue (0);

end Buffer_Example;
