with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Buffer;
use type Buffer.Byte;
with Code_Page_310;
with Code_Page_500;
with Box_Drawing;
with IBM_3270_Orders;
with Byte_Text_IO;
with Input_Stream;
with IBM_3270;
with Panel_Elements;
with Lines;

package body Menu_Views is

   function Normal_Text return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Normal_Text;

   function Highlighted return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Highlighted;

   P : aliased Code_Page_500.Page_500;

   procedure To_Physical (
      V : Menu_View;
      Bytes_Out : in out Byte_Vectors.Vector) is
      B : Byte_Vectors.Vector;
      L : Lines.Bounded_Wide_String;
   begin

      Panel_Elements.Box_Top (0, P'Access, Bytes_Out);

      Panel_Elements.Text_Line (1,
         P'Access,
         V.Title,
         Bytes_Out);

      Panel_Elements.Horizontal_Rule (2, P'Access, Bytes_Out);

      for J in 1 .. 4 loop
         Panel_Elements.Box_Sides (2 * J + 1, P'Access, Bytes_Out);

         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Highlighted);
         Code_Page_310.Append (Bytes_Out, '[');
         IBM_3270_Orders.Start_Field (Bytes_Out,
            False,
            IBM_3270_Orders.Detectable);
         if J = 1 then
            IBM_3270_Orders.Insert_Cursor (Bytes_Out);
         end if;
         P.Append (Bytes_Out, " ");
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Highlighted);
         Code_Page_310.Append (Bytes_Out, ']');
         P.Append (Bytes_Out, " Option");
         P.Append (Bytes_Out, Natural'Wide_Image (J));
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 78, 2 * J + 2);
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      end loop;

   end To_Physical;

   procedure From_Physical (
      V : in out Menu_View;
      Bytes_In : Byte_Vectors.Vector) is
   begin

      Input_Stream.Parse (V, P'Access, Bytes_In);

   end From_Physical;

   procedure Update_AID (
      V : in out Menu_View;
      AID : Buffer.Byte) is
   begin

      V.AID := AID;

   end Update_AID;

   procedure Update_Cursor (
      V : in out Menu_View;
      X : Natural;
      Y : Natural) is
   begin

      if V.AID = IBM_3270.AID_CrSel then
         if (Y mod 2 = 0) and (Y >= 4) and (Y <= 10) then
            V.Option := (Y - 2) / 2;
            --  Ada.Text_IO.Put ("Option = ");
            --  Ada.Integer_Text_IO.Put (V.Option);
            --  Ada.Text_IO.New_Line;
         else
            V.Option := 0;
         end if;
      end if;

   end Update_Cursor;

   procedure Update_Field (
      V : in out Menu_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String) is
   begin
      null;
   end Update_Field;

   function Get_AID (V : Menu_View) return Buffer.Byte is
   begin

      return V.AID;

   end Get_AID;

   procedure Set_Title (
      V : in out Menu_View;
      L : Lines.Bounded_Wide_String) is
   begin

      V.Title := L;

   end Set_Title;

end Menu_Views;
