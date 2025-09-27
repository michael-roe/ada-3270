with Ada.Containers; use Ada.Containers;
with AUnit.Assertions; use AUnit.Assertions;
with Buffer; use Buffer; use type Buffer.Byte;
with Buffer_Queues;

package body Buffer_Queues_Tests is

   procedure Test_Clear (T : in out Test_Cases.Test_Case'Class) is
      Q : Buffer_Queues.Queue;
   begin

      Assert (Q.Current_Use = 0,
        "Queue should be initialized as empty");

      Q.Clear;
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

   procedure Register_Tests (T : in out Buffer_Queues_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Clear'Access,
         "Test_Clear");

      Register_Routine (T, Test_Enqueue_Dequeue'Access,
         "Test_Enqueue_Dequeue");

      Register_Routine (T, Test_TX_RX'Access,
         "Test_TX_RX");

   end Register_Tests;

   function Name (T : Buffer_Queues_Test) return Test_String is
   begin

      return Format ("Buffer_Queues_Tests");

   end Name;

end Buffer_Queues_Tests;
