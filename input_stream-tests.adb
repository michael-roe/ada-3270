with AUnit.Assertions; use AUnit.Assertions;
with Ada.Text_IO;
with Ada.Wide_Text_IO;
with Views;
with Byte_Vectors;
with IBM_3270;
with IBM_3270_Orders;
with Code_Page_500;
with Lines; use type Lines.Bounded_Wide_String;

package body Input_Stream.Tests is

   procedure To_Physical (
      V : Test_View;
      Bytes_Out : in out Byte_Vectors.Vector) is
   begin

      null;

   end To_Physical;

   procedure From_Physical (
      V : in out Test_View;
      Bytes_In : Byte_Vectors.Vector) is
   begin

      Input_Stream.Parse (V, Bytes_In);

   end From_Physical;

   procedure Update_Field (
      V : in out Test_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String) is
   begin

      V.Field_Count := V.Field_Count + 1;
      V.Last_Field := L;

   end Update_Field;

   procedure Test_Duplicate (T : in out Test_Cases.Test_Case'Class) is
      V : Test_View;
      Bytes_In : Byte_Vectors.Vector;
      L : Lines.Bounded_Wide_String;
   begin

      Bytes_In.Append (IBM_3270.AID_Enter);
      Bytes_In.Append (16#40#);
      Bytes_In.Append (16#40#);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In, 1, 2);
      Code_Page_500.Append (Bytes_In, "(");
      Bytes_In.Append (IBM_3270.Duplicate);
      Code_Page_500.Append (Bytes_In, ")");

      V.From_Physical (Bytes_In);

      Assert (V.Field_Count = 1, "Update_Field should be called once");
      Lines.Set_Bounded_Wide_String (L, "()");
      Assert (V.Last_Field = L, "DUP should be omitted from field");

   end Test_Duplicate;

   procedure Register_Tests (T : in out Input_Stream_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Duplicate'Access,
         "Test_Duplicate");

   end Register_Tests;

   function Name (T : Input_Stream_Test) return Message_String is
   begin

      return Format ("Input_Stream_Tests");

   end Name;

end Input_Stream.Tests;
