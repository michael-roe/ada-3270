with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package Numbered_Menu_Views.Tests is

   type Numbered_Menu_View_Test is new Test_Cases.Test_Case with null record;

   procedure Test_Short_Read (T : in out Test_Cases.Test_Case'Class);

   procedure Test_Enter (T : in out Test_Cases.Test_Case'Class);

   procedure Register_Tests (T : in out Numbered_Menu_View_Test);

   function Name (T : Numbered_Menu_View_Test) return Message_String;

end Numbered_Menu_Views.Tests;
