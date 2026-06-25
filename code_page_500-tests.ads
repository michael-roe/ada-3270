with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package Code_Page_500.Tests is

   type Code_Page_Test is new Test_Cases.Test_Case with null record;

   procedure Test_Round_Trip (T : in out Test_Cases.Test_Case'Class);

   procedure Register_Tests (T : in out Code_Page_Test);

   function Name (T : Code_Page_Test) return Message_String;

end Code_Page_500.Tests;
