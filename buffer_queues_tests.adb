with Ada.Containers; use Ada.Containers;
with AUnit.Assertions; use AUnit.Assertions;
with Buffer; use Buffer; use type Buffer.Byte;
with Buffer_Queues;

package body Buffer_Queues_Tests is

   procedure Test_Clear (T : in out Test_Cases.Test_Case'Class) is
      Q : Buffer_Queues.Queue;
   begin

      Assert (Q.Is_Empty,
         "Queue should be initialized as empty");
      Assert (Q.Current_Use = 0,
        "Queue should be initialized as empty");

      Q.Clear;
      Assert (Q.Is_Empty,
         "Queue should be empty after Clear");
      Assert (Q.Current_Use = 0,
        "Queue should be empty after Clear");
      Assert (Q.Peak_Use = 0,
        "Peak_Use should be zero after Clear");

   end Test_Clear;

   procedure Test_Enqueue_Dequeue (T : in out Test_Cases.Test_Case'Class) is
      Q : Buffer_Queues.Queue;
      Byte_Sent : constant Buffer.Byte := 42;
      Byte_Received : Buffer.Byte;
   begin

      Q.Clear;

      Q.Enqueue (Byte_Sent);

      Byte_Received := 0;
      Q.Dequeue (Byte_Received);
      Assert (Byte_Sent = Byte_Received,
         "The value received should be the value that was sent");
      Assert (Q.Current_Use = 0,
         "Current_Use should be zero after the data has been dequeued");

   end Test_Enqueue_Dequeue;

   procedure Test_TX_RX (T : in out Test_Cases.Test_Case'Class) is
      TX : Buffer_Queues.Queue;
      RX : Buffer_Queues.Queue;
      Byte_Sent : constant Buffer.Byte := 42;
      Byte_Received : Buffer.Byte;
      task Server;
      task body Server is
         Byte_Echoed : Buffer.Byte;
      begin
         --
         --  The Server echoes one byte and then quits
         --
         --  For the server, receive and transmit are swapped
         --
         TX.Dequeue (Byte_Echoed);
         RX.Enqueue (Byte_Echoed);
      end Server;
   begin

      RX.Clear;
      TX.Clear;

      TX.Enqueue (Byte_Sent);

      RX.Dequeue (Byte_Received);
      Assert (Byte_Sent = Byte_Received,
         "Byte received from the echo server should equal the byte sent");

   end Test_TX_RX;

   procedure Test_TX_RX_Large (T : in out Test_Cases.Test_Case'Class) is
      TX : Buffer_Queues.Queue;
      RX : Buffer_Queues.Queue;
      Byte_Sent : constant Buffer.Byte := 42;
      Byte_Received : Buffer.Byte;
      Finished : Boolean;
      task Server;
      task body Server is
         Byte_Server : Buffer.Byte;
      begin
         --
         --  The Server receives data until it gets a NULL, then
         --  replies with a NULL.
         --
         --  For the server, receive and transmit are swapped
         --
         --  Put in a small delay here so that the buffer will probably
         --  fill up before the server empties it; this will test the
         --  buffer full condition.
         delay 0.1;
         Finished := False;
         while not Finished loop
            TX.Dequeue (Byte_Server);
            if Byte_Server = 0 then
               Finished := True;
            end if;
         end loop;
         RX.Enqueue (0);
      end Server;
   begin
      TX.Clear;
      RX.Clear;
      for J in 1 .. Buffer.Buffer_Size * 2 loop
         TX.Enqueue (Byte_Sent);
      end loop;
      TX.Enqueue (0);

      RX.Dequeue (Byte_Received);
      Assert (Byte_Received = 0,
         "Reply from server should be terminated with NULL");

   end Test_TX_RX_Large;

   procedure Test_TX_RX_Break (T : in out Test_Cases.Test_Case'Class) is
      TX : Buffer_Queues.Queue;
      RX : Buffer_Queues.Queue;
      Byte_Sent : constant Buffer.Byte := 42;
      Byte_Received : Buffer.Byte;
      Finished : Boolean;
      task Server;
      task body Server is
         Byte_Server  : Buffer.Byte;
         Count_Server : Integer;
      begin
         --  The Server receives data until it receives a NULL, then replies
         --  with a NULL. It also sends a 1 (indicating that the client
         --  should quit sending) when it has received 2 bytes.
         Count_Server := 0;
         Finished := False;
         while not Finished loop
            TX.Dequeue (Byte_Server);
            if Byte_Server = 0 then
               Finished := True;
            else
               Count_Server := Count_Server + 1;
               if Count_Server = 2 then
                 RX.Enqueue (1);
               end if;
            end if;
         end loop;
         RX.Enqueue (0);
      end Server; 
   begin
      null;
      TX.Clear;
      RX.Clear;
      --  Send data until we have sent Buffer_Size * 2 bytes, or we have
      --  received something (should be a 1, stop sending, byte) from the
      --  Server.
      for J in 1 .. Buffer.Buffer_Size * 2 loop
         TX.Enqueue (Byte_Sent);
         if not RX.Is_Empty then
            exit;
         end if;
      end loop;
      TX.Enqueue (0);
      RX.Dequeue (Byte_Received);
      Assert (Byte_Received = 1,
         "Expected a 1 (BREAK) byte");
      RX.Dequeue (Byte_Received);
      Assert (Byte_Received = 0,
         "Expected a 0 (EOR) byte");
   end Test_TX_RX_Break;

   procedure Register_Tests (T : in out Buffer_Queues_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Clear'Access,
         "Test_Clear");

      Register_Routine (T, Test_Enqueue_Dequeue'Access,
         "Test_Enqueue_Dequeue");

      Register_Routine (T, Test_TX_RX'Access,
         "Test_TX_RX");

      Register_Routine (T, Test_TX_RX_Large'Access,
         "Test_TX_RX_Large");

      Register_Routine (T, Test_TX_RX_Break'Access,
         "Test_TX_RX_Break");

   end Register_Tests;

   function Name (T : Buffer_Queues_Test) return Test_String is
   begin

      return Format ("Buffer_Queues_Tests");

   end Name;

end Buffer_Queues_Tests;
