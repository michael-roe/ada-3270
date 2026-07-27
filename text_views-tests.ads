with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package Text_Views.Tests is

   type Text_View_Test is new Test_Cases.Test_Case with null record;

   procedure Test_Short_Read (T : in out Test_Cases.Test_Case'Class);

   procedure Register_Tests (T : in out Text_View_Test);

   function Name (T : Text_View_Test) return Message_String;

end Text_Views.Tests;
