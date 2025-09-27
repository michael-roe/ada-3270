with Ada.Containers; use Ada.Containers;
with AUnit.Assertions; use AUnit.Assertions;
with Buffer; use Buffer;
use type Buffer.Byte;

package body Buffer_Tests is

   procedure Test_Clear (T : in out Test_Cases.Test_Case'Class) is
      Buff : Buffer.T;
   begin

      Clear (Buff);

      Assert (Is_Empty (Buff),
          "Buffer should be empty after Clear");

      Assert (not Is_Full (Buff),
          "Buffer should not be full after Clear");

      Assert (Current_Use (Buff) = 0,
          "Current_Use should be 0 after Clear");

   end Test_Clear;

   procedure Test_Enqueue_Dequeue (T : in out Test_Cases.Test_Case'Class) is
      Buff : Buffer.T;
      Sent_Byte : constant Byte := 42;
      Received_Byte : Byte := 0;
      Success : Boolean;
   begin

      Clear (Buff);

      Assert (Is_Empty (Buff),
         "Buffer should be empty after Clear");

      Success := Enqueue_Tail (Buff, Sent_Byte);

      Assert (Success,
         "Enqueue failed when buffer had space");

      Assert (not Is_Empty (Buff),
         "Buffer should not be empty after Enqueue");

      Assert (not Is_Full (Buff),
          "Buffer should not be full after single Enqueue");

      Assert (Current_Use (Buff) = 1,
         "Current_Use should be 1 after single Enqueue");

      Success := Dequeue_Head (Buff, Received_Byte);

      Assert (Success,
         "Dequeue failed when buffer had data");

      Assert (Sent_Byte = Received_Byte,
          "Dequeued value didn't match expected value");

      Assert (Is_Empty (Buff),
         "Buffer should be empty after Dequeue");

   end Test_Enqueue_Dequeue;

   procedure Test_Full (T : in out Test_Cases.Test_Case'Class) is
      Buff : Buffer.T;
      Sent_Byte : constant Byte := 42;
      Success : Boolean;
   begin
      Clear (Buff);
      while not Is_Full (Buff) loop
         Success := Enqueue_Tail (Buff, Sent_Byte);
         Assert (Success, "Enqueue should succeed if buffer is not full");
      end loop;

      Success := Enqueue_Tail (Buff, Sent_Byte);
      Assert (not Success, "Enqueue should fail if buffer is full");

   end Test_Full;

   procedure Register_Tests (T : in out Buffer_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Clear'Access,
         "Test_Clear");

      Register_Routine (T, Test_Enqueue_Dequeue'Access,
         "Test_Enqueue_Dequeue");

      Register_Routine (T, Test_Full'Access,
         "Test_Full");

   end Register_Tests;

   function Name (T : Buffer_Test) return Test_String is
   begin
      return Format ("Buffer_Tests");
   end Name;

end Buffer_Tests;
