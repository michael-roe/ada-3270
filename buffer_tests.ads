with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package Buffer_Tests is

   type Buffer_Test is new Test_Cases.Test_Case with null record;

   procedure Register_Tests (T : in out Buffer_Test);

   function Name (T : Buffer_Test) return Message_String;

   procedure Test_Clear (T : in out Test_Cases.Test_Case'Class);

   procedure Test_Enqueue_Dequeue (T : in out Test_Cases.Test_Case'Class);

   procedure Test_Full (T : in out Test_Cases.Test_Case'Class);

   procedure Test_Wrap (T : in out Test_Cases.Test_Case'Class);

end Buffer_Tests;
