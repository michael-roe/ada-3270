with Ada.Containers; use Ada.Containers;
with AUnit.Assertions; use AUnit.Assertions;
with Buffer_Queues;

package body Buffer_Queues_Tests is

   procedure Test_Clear (T : in out Test_Cases.Test_Case'Class) is
      Q : Buffer_Queues.Queue;
   begin
      Q.Clear;
      Assert (Q.Current_Use = 0,
        "Queue should start out empty");
   end Test_Clear;

   procedure Register_Tests (T : in out Buffer_Queues_Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Clear'Access,
         "Test_Clear");
   end Register_Tests;

   function Name (T : Buffer_Queues_Test) return Test_String is
   begin
      return Format ("Buffer_Queues_Tests");
   end Name;

end Buffer_Queues_Tests;
