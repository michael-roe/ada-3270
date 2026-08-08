with Ada.Text_IO;
with Ada.Containers;
use type Ada.Containers.Count_Type;
with Code_Page_310;
with Code_Page_500;
with Box_Drawing;
with Block_Elements;
with IBM_3270_Orders;
with IBM_3270.Input_Stream;
with Panel_Elements;

package body Progress_Views is

   function Normal_Text return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Normal_Text;

   function Highlighted return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Highlighted;

   procedure To_Physical (
      V : Progress_View;
      Bytes_Out : in out Byte_Vectors.Vector;
      P : Code_Pages.Code_Page_Access) is
      B : Byte_Vectors.Vector;
      L : Lines.Bounded_Wide_String;
   begin

      Panel_Elements.Box_Top (0, P, Bytes_Out);

      Panel_Elements.Text_Line (1, P, V.Title, Bytes_Out);

      Panel_Elements.Horizontal_Rule (2, P, Bytes_Out);

      Panel_Elements.Box_Sides (3, P, Bytes_Out);

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 4);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      P.Append (Bytes_Out, " ");
      P.Append (Bytes_Out, "Thinking");
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 17, 4);
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      P.Append (Bytes_Out, "[");
      for J in 1 .. 40 loop
         Code_Page_310.Append (Bytes_Out, Block_Elements.Full);
      end loop;
      P.Append (Bytes_Out, "]");
      P.Append (Bytes_Out, " ");
      P.Append (Bytes_Out, "99%");
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 4);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      Panel_Elements.Box_Sides (5,  P, Bytes_Out);

      for J in 6 .. 41 loop
         Panel_Elements.Box_Sides (J, P, Bytes_Out);
      end loop;

      Panel_Elements.Box_Bottom (42, P, Bytes_Out);

   end To_Physical;

   procedure From_Physical (
      V : in out Progress_View;
      Bytes_In : Byte_Vectors.Vector;
      P : Code_Pages.Code_Page_Access) is
   begin

      IBM_3270.Input_Stream.Parse (V, P, Bytes_In);

   end From_Physical;

   procedure Update_Cursor (
      V : in out Progress_View;
      X : Natural;
      Y : Natural) is
   begin

      null;

   end Update_Cursor;

   procedure Update_AID (
      V : in out Progress_View;
      AID : Buffer.Byte) is
   begin

      V.AID := AID;

   end Update_AID;

   procedure Update_Field (
      V : in out Progress_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String) is
   begin

      null;

   end Update_Field;

   function Get_AID (V : Progress_View) return Buffer.Byte is
   begin

      return V.AID;

   end Get_AID;

   procedure Prev_Page (V : in out Progress_View) is
   begin

      null;

   end Prev_Page;

   procedure Next_Page (V : in out Progress_View) is
   begin

      null;

   end Next_Page;

   procedure Set_Title (
      V : in out Progress_View;
      L : Lines.Bounded_Wide_String) is
   begin

      V.Title := L;

   end Set_Title;

   procedure Set_Subtitle (
      V : in out Progress_View;
      L : Lines.Bounded_Wide_String) is
   begin

      null;
      --  V.Subtitle := L;

   end Set_Subtitle;

end Progress_Views;
