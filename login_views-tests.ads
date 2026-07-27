with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package Login_Views.Tests is

   type Login_View_Test is new Test_Cases.Test_Case with null record;

   procedure Test_Short_Read (T : in out Test_Cases.Test_Case'Class);

   procedure Register_Tests (T : in out Login_View_Test);

   function Name (T : Login_View_Test) return Message_String;

end Login_Views.Tests;
