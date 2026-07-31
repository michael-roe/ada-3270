with AUnit.Assertions; use AUnit.Assertions;
with Ada.Containers; use type Ada.Containers.Count_Type;
with Lines;
with Byte_Vectors;
with Line_Vectors;
with IBM_3270;
with IBM_3270_Orders;
with Output_Stream;
with Code_Page_500;
with Buffer; use type Buffer.Byte;

package body Login_Views.Tests is

   P : aliased Code_Page_500.Page_500;

   Field_Count : Natural;

   Cursor_X_1 : Natural;

   Cursor_Y_1 : Natural;

   Cursor_X_2 : Natural;

   Cursor_Y_2 : Natural;

   procedure Update_Field (X : Natural; Y : Natural) is
   begin

      if Field_Count = 0 then
         Cursor_X_1 := X;
         Cursor_Y_1 := Y;
      elsif Field_Count = 1 then
         Cursor_X_2 := X;
         Cursor_Y_2 := Y;
      end if;

      Field_Count := Field_Count + 1;

   end Update_Field;

   procedure Parse is new Output_Stream.Parse (Update_Field => Update_Field);

   procedure Test_Short_Read (T : in out Test_Cases.Test_Case'Class) is
      V : Login_View;
      Bytes_Out : Byte_Vectors.Vector;
      Bytes_In : Byte_Vectors.Vector;
      L : Lines.Bounded_Wide_String;
   begin

      Lines.Set_Bounded_Wide_String (L, "Login");
      V.Set_Title (L);

      V.To_Physical (Bytes_Out);

      Bytes_In.Append (IBM_3270.AID_PA1);

      V.From_Physical (Bytes_In);

      Assert (V.Get_AID = IBM_3270.AID_PA1, "AID should be PA1");

   end Test_Short_Read;

   procedure Test_Enter (T : in out Test_Cases.Test_Case'Class) is
      V : Login_View;
      Bytes_Out : Byte_Vectors.Vector;
      Bytes_In : Byte_Vectors.Vector;
      L : Lines.Bounded_Wide_String;
   begin

      Lines.Set_Bounded_Wide_String (L, "Login ");
      V.Set_Title (L);

      V.To_Physical (Bytes_Out);

      Field_Count := 0;
      Parse (Bytes_Out);

      Assert (Field_Count = 2, "Field_Count should be 2");

      --
      --  These are not, of course, valid login credentials.
      --  They are just to test that password input works.
      --

      Bytes_In.Append (IBM_3270.AID_Enter);
      IBM_3270_Orders.Append_Buffer_Address (Bytes_In, 0, 0);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In,
         Cursor_X_1 + 1,
         Cursor_Y_1);
      P.Append (Bytes_In, "guest");
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In,
         Cursor_X_2 + 1,
         Cursor_Y_2);
      P.Append (Bytes_In, "123456");

      V.From_Physical (Bytes_In);

   end Test_Enter;

   procedure Register_Tests (T : in out Login_View_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Short_Read'Access,
         "Test_Short_Read");

      Register_Routine (T, Test_Enter'Access,
         "Test_Enter");

   end Register_Tests;

   function Name (T : Login_View_Test) return Message_String is
   begin
      return Format ("Login_Views_Tests");
   end Name;

end Login_Views.Tests;
