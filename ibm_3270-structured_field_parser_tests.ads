with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package IBM_3270.Structured_Field_Parser_Tests is

   type SF_Parser_Test is new Test_Cases.Test_Case with null record;

   procedure Test_Code_Page (T : in out Test_Cases.Test_Case'Class);

   procedure Register_Tests (T : in out SF_Parser_Test);

   function Name (T : SF_Parser_Test) return Message_String;

end IBM_3270.Structured_Field_Parser_Tests;
