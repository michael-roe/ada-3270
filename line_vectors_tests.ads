with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package Line_Vectors_Tests is

   type Line_Vectors_Test is new Test_Cases.Test_Case with null record;

   procedure Test_Append (T : in out Test_Cases.Test_Case'Class);

   procedure Register_Tests (T : in out Line_Vectors_Test);

   function Name (T : Line_Vectors_Test) return Message_String;

end Line_Vectors_Tests;
