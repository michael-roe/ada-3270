with AUnit.Assertions; use AUnit.Assertions;
with Ada.Containers; use type Ada.Containers.Count_Type;
with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Wide_Text_IO;
with Lines;
use type Lines.Bounded_Wide_String;
with Byte_Vectors;
with Line_Vectors;
with IBM_3270;
with IBM_3270_Orders;
with Buffer; use type Buffer.Byte;
with Output_Stream;
with Code_Page_500;

package body Numbered_Menu_Views.Tests is

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
      --   Ada.Text_IO.Put ("(");
      --   Ada.Integer_Text_IO.Put (X);
      --   Ada.Text_IO.Put (",");
      --   Ada.Integer_Text_IO.Put (Y);
      --   Ada.Text_IO.Put (")");
      --   Ada.Text_IO.New_Line;
      end if;

   end Update_Field;

   procedure Parse is new Output_Stream.Parse (Update_Field => Update_Field);

   procedure Test_Short_Read (T : in out Test_Cases.Test_Case'Class) is
      V : Numbered_Menu_View;
      Bytes_Out : Byte_Vectors.Vector;
      Bytes_In : Byte_Vectors.Vector;
   begin

      V.To_Physical (Bytes_Out);

      First_Field := True;
      Parse (Bytes_Out);

      Bytes_In.Append (IBM_3270.AID_PA1);

      V.From_Physical (Bytes_In);

      Assert (V.Get_AID = IBM_3270.AID_PA1, "AID should be PA1");

   end Test_Short_Read;

   procedure Test_Enter (T : in out Test_Cases.Test_Case'Class) is
      V : Numbered_Menu_View;
      Bytes_Out : Byte_Vectors.Vector;
      Bytes_In : Byte_Vectors.Vector;
      L : Lines.Bounded_Wide_String;
   begin

      V.To_Physical (Bytes_Out);

      First_Field := True;
      Parse (Bytes_Out);

      Bytes_In.Append (IBM_3270.AID_Enter);
      Bytes_In.Append (16#40#);
      Bytes_In.Append (16#40#);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In, Cursor_X + 1, Cursor_Y);
      P.Append (Bytes_In, "1");

      V.From_Physical (Bytes_In);

      Assert (V.Option = 1, "Option should be 1");

   end Test_Enter;

   procedure Register_Tests (T : in out Numbered_Menu_View_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Short_Read'Access,
         "Test_Short_Read");

      Register_Routine (T, Test_Enter'Access,
         "Test_Enter");

   end Register_Tests;

   function Name (T : Numbered_Menu_View_Test) return Message_String is
   begin
      return Format ("Numbered_Menu_Views_Tests");
   end Name;

end Numbered_Menu_Views.Tests;
