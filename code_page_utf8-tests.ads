with AUnit;
with AUnit.Test_Cases;

package Code_Page_UTF8.Tests is

   type UTF8_Test is new AUnit.Test_Cases.Test_Case with null record;

   procedure Test_One_Byte (T : in out AUnit.Test_Cases.Test_Case'Class);

   procedure Test_Two_Bytes (T : in out AUnit.Test_Cases.Test_Case'Class);

   procedure Register_Tests (T : in out UTF8_Test);

   function Name (T : UTF8_Test) return AUnit.Message_String;

end Code_Page_UTF8.Tests;
