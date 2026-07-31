with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Code_Page_310;
with Code_Page_500;
with Box_Drawing;
with IBM_3270;
with IBM_3270_Orders;
with Input_Stream;
with Ada.Text_IO;
with Ada.Wide_Text_IO;
with Byte_Text_IO;
with Buffer;
use type Buffer.Byte;
with Lines;
with Panel_Elements;

package body Login_Views is

   function Normal_Text return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Normal_Text;

   function Highlighted return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Highlighted;

   function Hidden return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Hidden;

   P : aliased Code_Page_500.Page_500;

   procedure To_Physical (
      V : Login_View;
      Bytes_Out : in out Byte_Vectors.Vector) is
      B : Byte_Vectors.Vector;
      L : Lines.Bounded_Wide_String;
   begin

      Panel_Elements.Box_Top (0, P'Access, Bytes_Out);

      Panel_Elements.Text_Line (1, P'Access, V.Title, Bytes_Out);

      Panel_Elements.Horizontal_Rule (2, P'Access, Bytes_Out);

      Panel_Elements.Box_Sides (3, P'Access, Bytes_Out);

      Lines.Set_Bounded_Wide_String (L,
         "Fill in your UserId and Password and press Enter");
      Panel_Elements.Text_Line (4, P'Access, L, Bytes_Out);

      Lines.Set_Bounded_Wide_String (L,
         "(Your password will not appear when you type it)");
      Panel_Elements.Text_Line (5, P'Access, L, Bytes_Out);

      Panel_Elements.Box_Sides (6, P'Access, Bytes_Out);

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 7);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Highlighted);
      P.Append (Bytes_Out, "UserId   ");
      IBM_3270_Orders.Start_Field (Bytes_Out, False, Normal_Text);
      IBM_3270_Orders.Insert_Cursor (Bytes_Out);
      P.Append (Bytes_Out, "            ");
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 7);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      Panel_Elements.Box_Sides (8, P'Access, Bytes_Out);

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 9);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Highlighted);
      P.Append (Bytes_Out, "Password ");
      IBM_3270_Orders.Start_Field (Bytes_Out, False, Hidden);
      P.Append (Bytes_Out, "            ");
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 9);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      for J in 10 .. 41 loop
         Panel_Elements.Box_Sides (J, P'Access, Bytes_Out);
      end loop;

      --
      --  The login screen does not have a function key area
      --

      Panel_Elements.Box_Bottom (42, P'Access, Bytes_Out);

   end To_Physical;

   procedure From_Physical (
      V : in out Login_View;
      Bytes_In : Byte_Vectors.Vector) is
   begin

      Input_Stream.Parse (V, P'Access, Bytes_In);

   end From_Physical;

   procedure Update_AID (
      V : in out Login_View;
      AID : Buffer.Byte) is
   begin

      V.AID := AID;

   end Update_AID;

   procedure Update_Cursor (
      V : in out Login_View;
      X : Natural;
      Y : Natural) is
   begin

      null;

   end Update_Cursor;

   procedure Update_Field (
      V : in out Login_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String) is
   begin

      --  Ada.Integer_Text_IO.Put (X);
      --  Ada.Text_IO.Put (",");
      --  Ada.Integer_Text_IO.Put (Y);
      --  Ada.Text_IO.New_Line;

      if (X = 12) and (Y = 7) then
         V.User_Id := L;
      elsif (X = 12) and (Y = 9) then
         V.Password := L;
      end if;

   end Update_Field;

   function Get_AID (V : Login_View) return Buffer.Byte is
   begin

      return V.AID;

   end Get_AID;

   procedure Set_Title (
      V : in out Login_View;
      L : Lines.Bounded_Wide_String) is
   begin

      V.Title := L;

   end Set_Title;

   function Get_User_Id (V : Login_View) return Lines.Bounded_Wide_String is
   begin

      return V.User_Id;

   end Get_User_Id;

   function Get_Password (V : Login_View) return Lines.Bounded_Wide_String is
   begin

      return V.Password;

   end Get_Password;

end Login_Views;
