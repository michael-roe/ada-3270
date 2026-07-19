with AUnit.Assertions; use AUnit.Assertions;
with Ada.Containers; use type Ada.Containers.Count_Type;
with Byte_Vectors;
with IBM_3270;
with Buffer; use type Buffer.Byte;

package body IBM_3270_Orders.Tests is

   procedure Test_Set_Buffer_Address (
      T : in out Test_Cases.Test_Case'Class) is
      Bytes_Out : Byte_Vectors.Vector;
      X : Natural;
      Y : Natural;
   begin

      Set_Buffer_Address (Bytes_Out, 1, 2);
      Assert (Bytes_Out.Length = 3, "SBA order should be 3 bytes");
      Assert (Bytes_Out.Element (Bytes_Out.First_Index) =
         IBM_3270.Set_Buffer_Address,
         "SBA order should start with SBA tag");
      IBM_3270_Orders.To_Buffer_Address (
         Bytes_Out.Element (Bytes_Out.First_Index + 1),
         Bytes_Out.Element (Bytes_Out.First_Index + 2),
         X,
         Y);
      Assert (X = 1, "Column address should be 1");
      Assert (Y = 2, "Row address should be 2");

   end Test_Set_Buffer_Address;

   procedure Test_Insert_Cursor (
      T : in out Test_Cases.Test_Case'Class) is
      Bytes_Out : Byte_Vectors.Vector;
   begin

      Insert_Cursor (Bytes_Out);
      Assert (Bytes_Out.Length = 1, "Insert Cursor order should be 1 byte");
      Assert (Bytes_Out.Element (Bytes_Out.First_Index) =
         IBM_3270.Insert_Cursor,
         "Insert Cursor order should be Insert Cursor tag");

   end Test_Insert_Cursor;

   procedure Test_To_Buffer_Address_Invalid (
      T : in out Test_Cases.Test_Case'Class) is
      X : Natural;
      Y : Natural;
      C1 : Buffer.Byte;
      C2 : Buffer.Byte;
   begin

      C1 := 16#A1#;
      C2 := 16#A1#;
      To_Buffer_Address (C1, C2, X, Y);
      Assert (X = 0, "Invalid character should decode as 0");
      Assert (Y = 0, "Invalid character should decode as 0");

   end Test_To_Buffer_Address_Invalid;   

   procedure Test_Is_Short_Read (
      T : in out Test_Cases.Test_Case'Class) is
   begin

      Assert (Is_Short_Read (IBM_3270.AID_PA1),
         "PA1 is a short read");

      Assert (Is_Short_Read (IBM_3270.AID_PA2),
         "PA2 is a short read");

      Assert (Is_Short_Read (IBM_3270.AID_PA3),
         "PA3 is a short read");

      Assert (Is_Short_Read (IBM_3270.AID_Clear),
         "Clear is a short read");

      Assert (not Is_Short_Read (IBM_3270.AID_Enter),
         "Enter is not a short read");

   end Test_Is_Short_Read;

   procedure Register_Tests (T : in out IBM_3270_Orders_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Set_Buffer_Address'Access,
         "Test_Set_Buffer_Address");

      Register_Routine (T, Test_Insert_Cursor'Access,
         "Test_Insert_Cursor");

      Register_Routine (T, Test_To_Buffer_Address_Invalid'Access,
         "Test_To_Buffer_Address_Invalid");

      Register_Routine (T, Test_Is_Short_Read'Access,
         "Test_Is_Short_Read");

   end Register_Tests;

   function Name (T : IBM_3270_Orders_Test) return Message_String is
   begin
      return Format ("IBM_3270_Orders_Tests");
   end Name;

end IBM_3270_Orders.Tests;
