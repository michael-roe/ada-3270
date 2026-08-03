with Ada.Text_IO;
with Ada.Containers;
use type Ada.Containers.Count_Type;
with Code_Page_310;
with Code_Page_500;
with Box_Drawing;
with IBM_3270_Orders;
with IBM_3270.Input_Stream;
with Panel_Elements;

package body Text_Views is

   function Normal_Text return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Normal_Text;

   function Highlighted return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Highlighted;

   P : aliased Code_Page_500.Page_500;

   procedure To_Physical (
      V : Text_View;
      Bytes_Out : in out Byte_Vectors.Vector;
      P : Code_Pages.Code_Page_Access) is
      B : Byte_Vectors.Vector;
      Line_Number : Natural;
   begin

      Panel_Elements.Box_Top (0, P, Bytes_Out);

      Panel_Elements.Text_Line (1, P, V.Title, Bytes_Out);

      Panel_Elements.Horizontal_Rule (2, P, Bytes_Out);

      Panel_Elements.Left_Input_Label (3,
         P,
         V.Subtitle,
         Bytes_Out);

      Panel_Elements.Right_Scroll_Up_Down (3,
         P,
         V.Page_Number /= 0,
         V.Page_Number <= Natural (V.Text.Length) / 36,
         Bytes_Out);

      for J in 4 .. 39 loop
         Line_Number := 36 * V.Page_Number + J - 4;
         if Line_Number <= V.Text.Last_Index then
            Panel_Elements.Input_Line (J,
               P,
               V.Text (Line_Number),
               J = 4,
               Bytes_Out);
         else
            Panel_Elements.Empty_Input_Line (J,
               P,
               J = 4,
               Bytes_Out);
         end if;
      end loop;

      Panel_Elements.Horizontal_Rule (40, P, Bytes_Out);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      P.Append (Bytes_Out, " PF1=Help");
      P.Append (Bytes_Out, " PF3=Exit");
      P.Append (Bytes_Out, " PF7=Prev");
      P.Append (Bytes_Out, " PF8=Next");
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 41);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      Panel_Elements.Box_Bottom (42, P, Bytes_Out);

   end To_Physical;

   procedure From_Physical (
      V : in out Text_View;
      Bytes_In : Byte_Vectors.Vector;
      P : Code_Pages.Code_Page_Access) is
   begin

      IBM_3270.Input_Stream.Parse (V, P, Bytes_In);

   end From_Physical;

   procedure Update_Cursor (
      V : in out Text_View;
      X : Natural;
      Y : Natural) is
   begin

      null;

   end Update_Cursor;

   procedure Update_AID (
      V : in out Text_View;
      AID : Buffer.Byte) is
   begin

      V.AID := AID;

   end Update_AID;

   procedure Update_Field (
      V : in out Text_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String) is
      Line_Number : Natural;
      Blank_Line : Lines.Bounded_Wide_String;
      Extra_Lines : Natural;
   begin

      --  Ada.Text_IO.Put ("(");
      --  Ada.Text_IO.Put (Natural'Image (X));
      --  Ada.Text_IO.Put (",");
      --  Ada.Text_IO.Put (Natural'Image (Y));
      --  Ada.Text_IO.Put (")");
      --  Ada.Text_IO.New_Line;
      Line_Number := 36 * V.Page_Number + Y - 4;
      if Line_Number > V.Text.Last_Index then
         Extra_Lines := Line_Number - V.Text.Last_Index;
         for J in 1 .. Extra_Lines - 1 loop
            Line_Vectors.Append (V.Text, Blank_Line);
         end loop;
         Line_Vectors.Append (V.Text, L);
      else
         Line_Vectors.Replace_Element (
            V.Text,
            Line_Number,
            L);
      end if;

   end Update_Field;

   function Get_AID (V : Text_View) return Buffer.Byte is
   begin

      return V.AID;

   end Get_AID;

   procedure Prev_Page (V : in out Text_View) is
   begin

      if V.Page_Number > 0 then
         V.Page_Number := V.Page_Number - 1;
      end if;

   end Prev_Page;

   procedure Next_Page (V : in out Text_View) is
   begin

      --
      --  Allow Next_Page to advance to a completely blank page
      --  beyond the end of the document so that the user can
      --  increase the number of pages. But don't allow two blank
      --  pages at the end.
      --
      if V.Page_Number <= Natural (V.Text.Length) / 36 then
         V.Page_Number := V.Page_Number + 1;
      end if;

   end Next_Page;

   procedure Set_Title (
      V : in out Text_View;
      L : Lines.Bounded_Wide_String) is
   begin

      V.Title := L;

   end Set_Title;

   procedure Set_Subtitle (
      V : in out Text_View;
      L : Lines.Bounded_Wide_String) is
   begin

      V.Subtitle := L;

   end Set_Subtitle;

end Text_Views;
