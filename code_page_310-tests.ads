with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package Code_Page_310.Tests is

   type Code_Page_Test is new Test_Cases.Test_Case with null record;

   procedure Test_National_Variants (T : in out Test_Cases.Test_Case'Class);

   procedure Test_Section_Sign (T : in out Test_Cases.Test_Case'Class);

   procedure Test_Box_Drawing (T : in out Test_Cases.Test_Case'Class);

   procedure Test_Block_Elements (T : in out Test_Cases.Test_Case'Class);

   procedure Test_Arrows (T : in out Test_Cases.Test_Case'Class);

   procedure Test_Math_Operators (T : in out Test_Cases.Test_Case'Class);

   procedure Test_Invalid (T : in out Test_Cases.Test_Case'Class);

   procedure Register_Tests (T : in out Code_Page_Test);

   function Name (T : Code_Page_Test) return Message_String;

end Code_Page_310.Tests;
