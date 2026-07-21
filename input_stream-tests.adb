with AUnit.Assertions; use AUnit.Assertions;
with Ada.Text_IO;
with Ada.Wide_Text_IO;
with Ada.Containers; use type Ada.Containers.Count_Type;
with Views;
with Byte_Vectors;
with IBM_3270;
with IBM_3270_Orders;
with Code_Page_310;
with Code_Page_500;
with Lines; use type Lines.Bounded_Wide_String;
with Math_Operators;

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

   procedure Update_Cursor (
      V : in out Test_View;
      X : Natural;
      Y : Natural) is
   begin    

      V.Cursor_X := X;
      V.Cursor_Y := Y;
      V.Cursor_Set := True;
         
   end Update_Cursor;

   procedure Update_Field (
      V : in out Test_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String) is
   begin

      V.Field_Count := V.Field_Count + 1;
      V.Last_Field := L;
      V.Last_X := X;
      V.Last_Y := Y;

   end Update_Field;

   procedure Test_Short_Read (T : in out Test_Cases.Test_Case'Class) is
      V : Test_View;
      Bytes_In : Byte_Vectors.Vector;
   begin

      Bytes_In.Append (IBM_3270.AID_PA1);

      V.From_Physical (Bytes_In);

      Assert (not V.Cursor_Set, "Update_Cursor should not have been called");

   end Test_Short_Read;

   procedure Test_Buffer_Address (T : in out Test_Cases.Test_Case'Class) is
      V : Test_View;
      Bytes_In : Byte_Vectors.Vector;
      L : Lines.Bounded_Wide_String;
   begin

      Bytes_In.Append (IBM_3270.AID_Enter);
      Bytes_In.Append (16#40#);
      Bytes_In.Append (16#C1#);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In, 1, 2);
      Code_Page_500.Append (Bytes_In, "*");
      Code_Page_310.Append (Bytes_In, Math_Operators.Logical_And);

      V.From_Physical (Bytes_In);

      Assert (V.Cursor_Set, "Update_Cursor should have been called");
      Assert (V.Cursor_X = 1, "Cursor_X should be 1");
      Assert (V.Cursor_Y = 0, "Cursor_Y should be 0");
      Assert (V.Field_Count = 1, "Update_Field should be called once");
      Assert (V.Last_X = 1, "X should be 1");
      Assert (V.Last_Y = 2, "Y should be 2");
      Assert (Lines.Length (V.Last_Field) = 2,
         "Field length should be 2");
      Lines.Set_Bounded_Wide_String (L, "*" & Math_Operators.Logical_And);
      Assert (V.Last_Field = L, "Field should contain 2 wide characters");

   end Test_Buffer_Address;

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

   procedure Test_Field_Mark (T : in out Test_Cases.Test_Case'Class) is
      V : Test_View;
      Bytes_In : Byte_Vectors.Vector;
      L : Lines.Bounded_Wide_String;
   begin

      Bytes_In.Append (IBM_3270.AID_Enter);
      Bytes_In.Append (16#40#);
      Bytes_In.Append (16#40#);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In, 1, 2);
      Code_Page_500.Append (Bytes_In, "(");
      Bytes_In.Append (IBM_3270.Field_Mark);
      Code_Page_500.Append (Bytes_In, ")");

      V.From_Physical (Bytes_In);

      Assert (V.Field_Count = 1, "Update_Field should be called once");
      Lines.Set_Bounded_Wide_String (L, "()");
      Assert (V.Last_Field = L, "FM should be omitted from field");

   end Test_Field_Mark;

   procedure Test_Overflow (T : in out Test_Cases.Test_Case'Class) is
      V : Test_View;
      Bytes_In : Byte_Vectors.Vector;
   begin

      Bytes_In.Append (IBM_3270.AID_Enter);
      Bytes_In.Append (16#40#);
      Bytes_In.Append (16#40#);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In, 1, 2);

      Code_Page_500.Append (Bytes_In, "(");

      for J in 1 .. 256 loop
         Code_Page_500.Append (Bytes_In, "*");
      end loop;

      Code_Page_500.Append (Bytes_In, ")");

      V.From_Physical (Bytes_In);

      Assert (Lines.Length (V.Last_Field) = Lines.Max_Length,
         "A too long field should be truncated to fit");

   end Test_Overflow;

   procedure Register_Tests (T : in out Input_Stream_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Short_Read'Access,
         "Test_Short_Read");

      Register_Routine (T, Test_Buffer_Address'Access,
         "Test_Buffer_Address");

      Register_Routine (T, Test_Duplicate'Access,
         "Test_Duplicate");

      Register_Routine (T, Test_Field_Mark'Access,
         "Test_Field_Mark");

      Register_Routine (T, Test_Overflow'Access,
         "Test_Overflow");

   end Register_Tests;

   function Name (T : Input_Stream_Test) return Message_String is
   begin

      return Format ("Input_Stream_Tests");

   end Name;

end Input_Stream.Tests;
