with AUnit.Assertions; use AUnit.Assertions;
with Ada.Containers; use type Ada.Containers.Count_Type;
with Lines;
with Byte_Vectors;
with Line_Vectors;
with IBM_3270;
with Buffer; use type Buffer.Byte;
with IBM_3270.Output_Stream;
with IBM_3270_Orders;
with Code_Page_500;

package body Checkbox_Views.Tests is

   procedure Update_Field (X : Natural; Y : Natural);

   P : aliased Code_Page_500.Page_500;

   First_Field : Boolean;

   Cursor_X : Natural;

   Cursor_Y : Natural;

   procedure Update_Field (X : Natural; Y : Natural) is
   begin

      if First_Field then
         Cursor_X := X;
         Cursor_Y := Y;
         First_Field := False;
      end if;

   end Update_Field;

   procedure Parse is new IBM_3270.Output_Stream.Parse (
      Update_Field => Update_Field);

   procedure Test_Short_Read (T : in out Test_Cases.Test_Case'Class) is
      V : Checkbox_View;
      Bytes_Out : Byte_Vectors.Vector;
      Bytes_In : Byte_Vectors.Vector;
      L : Lines.Bounded_Wide_String;
   begin

      Lines.Set_Bounded_Wide_String (L, "Test Checkbox");
      V.Set_Title (L);
      Lines.Set_Bounded_Wide_String (L, "Apples");
      V.Set_Label (1, L);
      Lines.Set_Bounded_Wide_String (L, "Oranges");
      V.Set_Label (2, L);
      Lines.Set_Bounded_Wide_String (L, "Pears");
      V.Set_Label (3, L);
      Lines.Set_Bounded_Wide_String (L, "Bananas");
      V.Set_Label (4, L);
      V.To_Physical (Bytes_Out);

      V.Set_Checkbox (1, False);
      V.Set_Checkbox (2, False);
      V.Set_Checkbox (3, True);
      V.Set_Checkbox (4, True);

      Bytes_In.Append (IBM_3270.AID_PA1);

      V.From_Physical (Bytes_In);

      Assert (V.Get_AID = IBM_3270.AID_PA1, "AID should be PA1");

   end Test_Short_Read;

   procedure Test_Enter (T : in out Test_Cases.Test_Case'Class) is
      V : Checkbox_View;
      Bytes_Out : Byte_Vectors.Vector;
      Bytes_In : Byte_Vectors.Vector;
      L : Lines.Bounded_Wide_String;
   begin

      Lines.Set_Bounded_Wide_String (L, "Test Checkbox");
      V.Set_Title (L);
      Lines.Set_Bounded_Wide_String (L, "Apples");
      V.Set_Label (1, L);
      Lines.Set_Bounded_Wide_String (L, "Oranges");
      V.Set_Label (2, L);
      Lines.Set_Bounded_Wide_String (L, "Pears");
      V.Set_Label (3, L);
      Lines.Set_Bounded_Wide_String (L, "Bananas");
      V.Set_Label (4, L);

      V.Set_Checkbox (1, False);
      V.Set_Checkbox (2, False);
      V.Set_Checkbox (3, True);
      V.Set_Checkbox (4, True);

      V.To_Physical (Bytes_Out);

      First_Field := True;
      Parse (Bytes_Out);

      Bytes_In.Append (IBM_3270.AID_Enter);
      IBM_3270_Orders.Append_Buffer_Address (Bytes_In, 0, 0);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In,
         Cursor_X + 1,
         Cursor_Y);
      P.Append (Bytes_In, ">");

      V.From_Physical (Bytes_In);

      Assert (V.Checkboxes (1), "Checkbox 1 should be set");
      Assert (not V.Checkboxes (2), "Checkbox 2 should not be set");
      Assert (not V.Checkboxes (3), "Checkbox 3 should not be set");

   end Test_Enter;

   procedure Register_Tests (T : in out Checkbox_View_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Short_Read'Access,
         "Test_Short_Read");

      Register_Routine (T, Test_Enter'Access,
         "Test_Enter");

   end Register_Tests;

   function Name (T : Checkbox_View_Test) return Message_String is
   begin
      return Format ("Checkbox_Views_Tests");
   end Name;

end Checkbox_Views.Tests;
