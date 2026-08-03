with AUnit.Assertions; use AUnit.Assertions;
with Ada.Containers; use type Ada.Containers.Count_Type;
with Ada.Wide_Text_IO;
with Lines;
with Byte_Vectors;
with Line_Vectors;
with IBM_3270;
with IBM_3270_Orders;
with IBM_3270.Output_Stream;
with Buffer; use type Buffer.Byte;
with Code_Page_500;

package body Split_Views.Tests is

   procedure Update_Field (X : Natural; Y : Natural);

   P : aliased Code_Page_500.Page_500;

   Field_Count : Natural;

   Cursor_X : Natural;

   Cursor_Y : Natural;

   Cursor_X_2 : Natural;

   Cursor_Y_2 : Natural;

   procedure Update_Field (X : Natural; Y : Natural) is
   begin

      if Field_Count = 0 then
         Cursor_X := X;
         Cursor_Y := Y;
      elsif Field_Count = 1 then
         Cursor_X_2 := X;
         Cursor_Y_2 := Y;
      end if;

      Field_Count := Field_Count + 1;

   end Update_Field;

   procedure Parse is new IBM_3270.Output_Stream.Parse (
      Update_Field => Update_Field);

   procedure Test_Short_Read (T : in out Test_Cases.Test_Case'Class) is
      V : Split_View;
      Bytes_Out : Byte_Vectors.Vector;
      Bytes_In : Byte_Vectors.Vector;
   begin

      V.To_Physical (Bytes_Out);

      Bytes_In.Append (IBM_3270.AID_PA1);

      V.From_Physical (Bytes_In);

      Assert (V.Get_AID = IBM_3270.AID_PA1, "AID should be PA1");

   end Test_Short_Read;

   procedure Test_Enter (T : in out Test_Cases.Test_Case'Class) is
      V : Split_View;
      Bytes_Out : Byte_Vectors.Vector;
      Bytes_In : Byte_Vectors.Vector;
      L : Lines.Bounded_Wide_String;
   begin

      V.To_Physical (Bytes_Out);

      Field_Count := 0;
      Parse (Bytes_Out);

      Bytes_In.Append (IBM_3270.AID_Enter);
      IBM_3270_Orders.Append_Buffer_Address (Bytes_In, 0, 0);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In,
         Cursor_X + 1,
         Cursor_Y);
      P.Append (Bytes_In, "H");
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In,
         Cursor_X_2 + 1,
         Cursor_Y_2);
      P.Append (Bytes_In, "Hello World!");

      V.From_Physical (Bytes_In);

      Assert (V.Get_Option = 3, "Get_Option should return 3");
      Lines.Set_Bounded_Wide_String (L, "Hello World!");
      Assert (Lines.To_Wide_String (V.Edit (0)) = "Hello World!",
         "Edit window should be Hello World!");

   end Test_Enter;

   procedure Register_Tests (T : in out Split_View_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Short_Read'Access,
         "Test_Short_Read");

      Register_Routine (T, Test_Enter'Access,
         "Test_Enter");

   end Register_Tests;

   function Name (T : Split_View_Test) return Message_String is
   begin
      return Format ("Split_Views_Tests");
   end Name;

end Split_Views.Tests;
