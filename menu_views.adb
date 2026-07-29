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

      Panel_Elements.Left_Box_Side (3, P'Access, Bytes_Out);

      Panel_Elements.Right_Scroll_Up_Down (3,
         P'Access,
         False,
         False,
         Bytes_Out);

      Panel_Elements.Text_Line (4, P'Access, V.Intro, Bytes_Out);

      Panel_Elements.Box_Sides (5, P'Access, Bytes_Out);

      for J in 1 .. V.Last_Item loop
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 2 * J + 4);
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
         P.Append (Bytes_Out, " ");
         P.Append (Bytes_Out, Lines.To_Wide_String (V.Labels (J)));
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 78, 2 * J + 4);
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

         Panel_Elements.Box_Sides (2 * J + 5, P'Access, Bytes_Out);
      end loop;

      for J in 2 * V.Last_Item + 6 .. 39 loop
         Panel_Elements.Box_Sides (J, P'Access, Bytes_Out);
      end loop;

      Panel_Elements.Horizontal_Rule (40, P'Access, Bytes_Out);

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 41);
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
         if (Y mod 2 = 0) and (Y >= 6) and (Y <= 2 * Max_Items + 4) then
            V.Option := (Y - 4) / 2;
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

   procedure Prev_Page (V : in out Menu_View) is
   begin

      null;

   end Prev_Page;

   procedure Next_Page (V : in out Menu_View) is
   begin

      null;

   end Next_Page;

   procedure To_JSON (
      V : Menu_View;
      TX2 : access Buffer_Queues.Queue) is
      S : String := Natural'Image (V.Option);
   begin

      TX2.Enqueue (Character'Pos ('"'));
      for J in S'Range loop
         if S (J) /= ' ' then
            TX2.Enqueue (Character'Pos (S (J)));
         end if;
      end loop;
      TX2.Enqueue (Character'Pos ('"'));
      TX2.Enqueue (13);
      TX2.Enqueue (10);

   end To_JSON;

   procedure Set_Label (
      V : in out Menu_View;
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

end Menu_Views;
