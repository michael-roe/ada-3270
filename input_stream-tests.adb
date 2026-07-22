with AUnit.Assertions; use AUnit.Assertions;
with Ada.Text_IO;
with Ada.Wide_Text_IO;
with Ada.Containers; use type Ada.Containers.Count_Type;
with Buffer; use type Buffer.Byte;
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

   procedure Update_AID (
      V : in out Test_View;
      AID : Buffer.Byte) is
   begin

      V.AID := AID;
      V.AID_Set := True;

   end Update_AID;

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

      V.Last_Field := L;
      V.Last_X := X;
      V.Last_Y := Y;
      V.Field_Count := V.Field_Count + 1;
      if V.Field_Count = 1 then
         V.First_Field := L;
      end if;

   end Update_Field;

   procedure Test_Empty_Stream (T : in out Test_Cases.Test_Case'Class) is
      V : Test_View;
      Bytes_In : Byte_Vectors.Vector;
   begin

      V.From_Physical (Bytes_In);
      Assert (not V.AID_Set, "Update AID should not have been called");
      Assert (not V.Cursor_Set, "Update_Cursor should not have been called");
      Assert (V.Field_Count = 0, "Update_Field should not have been called");

   end Test_Empty_Stream;

   procedure Test_Short_Read (T : in out Test_Cases.Test_Case'Class) is
      V : Test_View;
      Bytes_In : Byte_Vectors.Vector;
   begin

      Bytes_In.Append (IBM_3270.AID_PA1);

      V.From_Physical (Bytes_In);

      Assert (V.AID_Set, "Update_AID should have been called");
      Assert (V.AID = IBM_3270.AID_PA1,
         "AID should be PA1");
      Assert (not V.Cursor_Set, "Update_Cursor should not have been called");
      Assert (V.Field_Count = 0, "Update_Field should not have been called");

   end Test_Short_Read;

   procedure Test_Cursor (T : in out Test_Cases.Test_Case'Class) is
      V : Test_View;
      Bytes_In : Byte_Vectors.Vector;
   begin

      Bytes_In.Append (IBM_3270.AID_Enter);
      Bytes_In.Append (16#40#);
      Bytes_In.Append (16#C1#);

      V.From_Physical (Bytes_In);

      Assert (V.AID_Set, "Update_AID should have been called");
      Assert (V.AID = IBM_3270.AID_Enter, "AID should be Enter");
      Assert (V.Cursor_Set, "Update_Cursor should have been called");
      Assert (V.Cursor_X = 1, "Cursor_X should be 1");
      Assert (V.Cursor_Y = 0, "Cursor_Y should be 0");
      Assert (V.Field_Count = 0, "Update_Field should not have been called");

   end Test_Cursor;

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

      Assert (V.AID_Set, "Update_AID should have been called");
      Assert (V.AID = IBM_3270.AID_Enter, "AID should be Enter");
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

   procedure Test_Trim (T : in out Test_Cases.Test_Case'Class) is
      V : Test_View;
      Bytes_In : Byte_Vectors.Vector;
      L : Lines.Bounded_Wide_String;
   begin

      Bytes_In.Append (IBM_3270.AID_Enter);
      Bytes_In.Append (16#40#);
      Bytes_In.Append (16#40#);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In, 1, 2);

      Code_Page_500.Append (Bytes_In, "Hello   ");

      V.From_Physical (Bytes_In);

      Lines.Set_Bounded_Wide_String (L, "Hello");
      Assert (V.Last_Field = L,
         "Trailing spaces should be trimmed from field");

  end Test_Trim;

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

   procedure Test_Two_Fields (T : in out Test_Cases.Test_Case'Class) is
      V : Test_View;
      Bytes_In : Byte_Vectors.Vector;
      L : Lines.Bounded_Wide_String;
   begin

      Bytes_In.Append (IBM_3270.AID_Enter);
      Bytes_In.Append (16#40#);
      Bytes_In.Append (16#40#);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In, 1, 2);
      Code_Page_500.Append (Bytes_In, "*");
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In, 1, 4);
      Code_Page_500.Append (Bytes_In, "Hello");

      V.From_Physical (Bytes_In);

      Assert (V.Field_Count = 2, "There should be two fields");
      Assert (V.Last_X = 1, "Last_X should be 1");
      Assert (V.Last_Y = 4, "Last_Y should be 4");
      Assert (Lines.Length (V.Last_Field) = 5,
         "Last field should be 5 characters long");
      Lines.Set_Bounded_Wide_String (L, "Hello");
      Assert (V.Last_Field = L, "Last_Field should be ""Hello""");

   end Test_Two_Fields;

   procedure Test_Trim_Two (T : in out Test_Cases.Test_Case'Class) is
      V : Test_View;
      Bytes_In : Byte_Vectors.Vector;
      L : Lines.Bounded_Wide_String;
   begin

      Bytes_In.Append (IBM_3270.AID_Enter);
      Bytes_In.Append (16#40#);
      Bytes_In.Append (16#40#);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In, 1, 2);
      Code_Page_500.Append (Bytes_In, "Hello   ");
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In, 1, 4);
      Code_Page_500.Append (Bytes_In, "World   ");

      V.From_Physical (Bytes_In);

      Assert (V.Field_Count = 2, "There should be two fields");
      Lines.Set_Bounded_Wide_String (L, "Hello");
      Assert (V.First_Field = L, "First_Field should be ""Hello""");
      Lines.Set_Bounded_Wide_String (L, "World");
      Assert (V.Last_Field = L, "Last_Field should be ""World""");

   end Test_Trim_Two;

   procedure Register_Tests (T : in out Input_Stream_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Empty_Stream'Access,
         "Test_Empty_Stream");

      Register_Routine (T, Test_Short_Read'Access,
         "Test_Short_Read");

      Register_Routine (T, Test_Cursor'Access,
         "Test_Cursor");

      Register_Routine (T, Test_Buffer_Address'Access,
         "Test_Buffer_Address");

      Register_Routine (T, Test_Duplicate'Access,
         "Test_Duplicate");

      Register_Routine (T, Test_Field_Mark'Access,
         "Test_Field_Mark");

      Register_Routine (T, Test_Trim'Access,
         "Test_Trim");

      Register_Routine (T, Test_Overflow'Access,
         "Test_Overflow");

      Register_Routine (T, Test_Two_Fields'Access,
         "Test_Two_Fields");

      Register_Routine (T, Test_Trim_Two'Access,
         "Test_Trim_Two");

   end Register_Tests;

   function Name (T : Input_Stream_Test) return Message_String is
   begin

      return Format ("Input_Stream_Tests");

   end Name;

end Input_Stream.Tests;
