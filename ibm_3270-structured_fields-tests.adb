with AUnit.Assertions; use AUnit.Assertions;
with Ada.Containers; use type Ada.Containers.Count_Type;
with Byte_Vectors;
with IBM_3270_Orders;

package body IBM_3270.Structured_Fields.Tests is

   procedure Test_Set_Reply_Mode (T : in out Test_Cases.Test_Case'Class) is
      Bytes_Out : Byte_Vectors.Vector;
   begin

      Set_Reply_Mode (Bytes_Out, IBM_3270_Orders.Character_Mode);

      Assert (Bytes_Out.Length = 5,
         "Length should be 5");
      Assert (Bytes_Out (Bytes_Out.First_Index) = 0,
         "Length MSB should be 0");
      Assert (Bytes_Out (Bytes_Out.First_Index + 1) = 5,
         "Length LSB should be 5");
      Assert (Bytes_Out (Bytes_Out.First_Index + 2) = 9,
         "Should be 9");
      Assert (Bytes_Out (Bytes_Out.First_Index + 3) = 0,
         "Should be 0");
      Assert (Bytes_Out (Bytes_Out.First_Index + 4) =
         IBM_3270_Orders.Reply_Mode'Pos (IBM_3270_Orders.Character_Mode),
         "Incorrect reply mode");

   end Test_Set_Reply_Mode;

   procedure Register_Tests (T : in out Structured_Fields_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Set_Reply_Mode'Access,
         "Test_Set_Reply_Mode");

   end Register_Tests;

   function Name (T : Structured_Fields_Test) return Message_String is
   begin
      return Format ("IBM_3270.Structured_Fields.Tests");
   end Name;

end IBM_3270.Structured_Fields.Tests;
