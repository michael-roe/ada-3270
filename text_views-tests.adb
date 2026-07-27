with AUnit.Assertions; use AUnit.Assertions;
with Ada.Containers; use type Ada.Containers.Count_Type;
with Lines;
with Byte_Vectors;
with Line_Vectors;
with IBM_3270;
with Buffer; use type Buffer.Byte;

package body Text_Views.Tests is

   procedure Test_Short_Read (T : in out Test_Cases.Test_Case'Class) is
      V : Text_View;
      Bytes_Out : Byte_Vectors.Vector;
      Bytes_In : Byte_Vectors.Vector;
   begin

      V.To_Physical (Bytes_Out);

      Bytes_In.Append (IBM_3270.AID_PA1);

      V.From_Physical (Bytes_In);

      Assert (V.Get_AID = IBM_3270.AID_PA1, "AID should be PA1");

   end Test_Short_Read;

   procedure Register_Tests (T : in out Text_View_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Short_Read'Access,
         "Test_Short_Read");

   end Register_Tests;

   function Name (T : Text_View_Test) return Message_String is
   begin
      return Format ("Text_Views_Tests");
   end Name;

end Text_Views.Tests;
