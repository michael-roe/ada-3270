with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package IBM_3270_Orders.Tests is

   type IBM_3270_Orders_Test is new Test_Cases.Test_Case with null record;

   procedure Test_Set_Buffer_Address (T : in out Test_Cases.Test_Case'Class);

   procedure Test_Insert_Cursor (T : in out Test_Cases.Test_Case'Class);

   procedure Register_Tests (T : in out IBM_3270_Orders_Test);

   function Name (T : IBM_3270_Orders_Test) return Message_String;

end IBM_3270_Orders.Tests;
