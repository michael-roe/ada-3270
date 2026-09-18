with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package IBM_3270.Structured_Fields.Tests is

   type Structured_Fields_Test is new Test_Cases.Test_Case with null record;

   procedure Test_Read_Partition_Query (T : in out Test_Cases.Test_Case'Class);

   procedure Test_Set_Reply_Mode (T : in out Test_Cases.Test_Case'Class);

   procedure Register_Tests (T : in out Structured_Fields_Test);

   function Name (T : Structured_Fields_Test) return Message_String;

end IBM_3270.Structured_Fields.Tests;
