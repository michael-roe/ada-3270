with Ada.Text_IO;
with Ada.Wide_Text_IO;
with Ada.Containers;
use type Ada.Containers.Count_Type;
with Buffer;
use type Buffer.Byte;
with Code_Page_310;
with Code_Page_500;
with Box_Drawing;
with IBM_3270;
with IBM_3270_Orders;
with IBM_3270.Input_Stream;
with Byte_Text_IO;
with Panel_Elements;

package body Checkbox_Views is

   function Normal_Text return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Normal_Text;

   function Highlighted return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Highlighted;

   P : aliased Code_Page_500.Page_500;

   procedure To_Physical (
      V : Checkbox_View;
      Bytes_Out : in out Byte_Vectors.Vector) is
      B : Byte_Vectors.Vector;
   begin

      Panel_Elements.Box_Top (0, P'Access, Bytes_Out);

      Panel_Elements.Text_Line (1, P'Access, V.Title, Bytes_Out);

      Panel_Elements.Horizontal_Rule (2, P'Access, Bytes_Out);

      for J in 1 .. 18 loop

         Panel_Elements.Box_Sides (2 * J + 1, P'Access, Bytes_Out);

         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Highlighted);
         Code_Page_310.Append (Bytes_Out, '[');

         if V.Checkboxes (J) then
            IBM_3270_Orders.Start_Field (Bytes_Out,
               False,
               IBM_3270_Orders.Detectable,
               Modified => True);
         else
            IBM_3270_Orders.Start_Field (Bytes_Out,
               False,
               IBM_3270_Orders.Detectable);
         end if;

         if J = 1 then
            IBM_3270_Orders.Insert_Cursor (Bytes_Out);
         end if;

         if V.Checkboxes (J) then
            P.Append (Bytes_Out, ">");
         else
            P.Append (Bytes_Out, "?");
         end if;

         IBM_3270_Orders.Start_Field (Bytes_Out, True, Highlighted);
         Code_Page_310.Append (Bytes_Out, ']');
         P.Append (Bytes_Out, " ");
         P.Append (Bytes_Out, Lines.To_Wide_String (V.Labels (J)));
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 2 * J + 2);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      end loop;

      Panel_Elements.Box_Sides (39, P'Access, Bytes_Out);

      Panel_Elements.Horizontal_Rule (40, P'Access, Bytes_Out);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      P.Append (Bytes_Out, " PF1=Help");
      P.Append (Bytes_Out, " PF3=Exit");
      P.Append (Bytes_Out, " PF7=Prev");
      P.Append (Bytes_Out, " PF8=Next");
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 41);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      Panel_Elements.Box_Bottom (42, P'Access, Bytes_Out);

   end To_Physical;

   procedure From_Physical (
      V : in out Checkbox_View;
      Bytes_In : Byte_Vectors.Vector) is
   begin

      if Bytes_In.Length >= 1 and then
         not IBM_3270_Orders.Is_Short_Read (
         Bytes_In.Element (Bytes_In.First_Index))
      then
         for J in 1 .. 4 loop
            V.Checkboxes (J) := False;
         end loop;
      end if;

      IBM_3270.Input_Stream.Parse (V, P'Access, Bytes_In);

   end From_Physical;

   procedure Update_AID (
      V : in out Checkbox_View;
      AID : Buffer.Byte) is
   begin

      V.AID := AID;

   end Update_AID;

   procedure Update_Cursor (
      V : in out Checkbox_View;
      X : Natural;
      Y : Natural) is
   begin

      null;

   end Update_Cursor;

   procedure Update_Field (
      V : in out Checkbox_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String) is
      F : Natural;
   begin

      if (X = 4) and (Y >= 4) and (Y <= 38) and (Y mod 2 = 0) then
         F := (Y - 4) / 2 + 1;
         --  Ada.Text_IO.Put ("Updating field ");
         --  Ada.Text_IO.Put (Natural'Image (F));
         --  Ada.Text_IO.New_Line;
         V.Checkboxes (F) := True;
      end if;

   end Update_Field;

   function Get_AID (V : Checkbox_View) return Buffer.Byte is
   begin

      return V.AID;

   end Get_AID;

   procedure Set_Title (
      V : in out Checkbox_View;
      L : Lines.Bounded_Wide_String) is
   begin

      V.Title := L;

   end Set_Title;

   procedure Set_Label (
      V : in out Checkbox_View;
      N : Natural;
      L : Lines.Bounded_Wide_String) is
   begin

      if N >= V.Labels'First and N <= V.Labels'Last then
         V.Labels (N) := L;
         if N > V.Last_Item then
            V.Last_Item := N;
         end if;
      end if;

   end Set_Label;

   procedure Set_Checkbox (
      V : in out Checkbox_View;
      N : Natural;
      Ticked : Boolean) is
   begin

      if N >= V.Labels'First and N <= V.Labels'Last then
         V.Checkboxes (N) := Ticked;
         if N > V.Last_Item then
            V.Last_Item := N;
         end if;
      end if;

   end Set_Checkbox;

end Checkbox_Views;
