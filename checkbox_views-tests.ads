with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package Checkbox_Views.Tests is

   type Checkbox_View_Test is new Test_Cases.Test_Case with null record;

   procedure Test_Short_Read (T : in out Test_Cases.Test_Case'Class);

   procedure Test_Enter (T : in out Test_Cases.Test_Case'Class);

   procedure Register_Tests (T : in out Checkbox_View_Test);

   function Name (T : Checkbox_View_Test) return Message_String;

end Checkbox_Views.Tests;
