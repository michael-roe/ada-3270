with Ada.Text_IO;
with Code_Page_310;
with Code_Page_500;
with Box_Drawing;
with IBM_3270_Orders;
with Byte_Text_IO;
with Input_Stream;
with Panel_Elements;

package body Numbered_Menu_Views is

   function Normal_Text return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Normal_Text;

   function Highlighted return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Highlighted;

   P : aliased Code_Page_500.Page_500;

   procedure To_Physical (
      V : Numbered_Menu_View;
      Bytes_Out : in out Byte_Vectors.Vector) is
      B : Byte_Vectors.Vector;
   begin

      Panel_Elements.Box_Top (0, P'Access, Bytes_Out);

      Panel_Elements.Text_Line (1, P'Access, V.Title, Bytes_Out);

      Panel_Elements.Horizontal_Rule (2, P'Access, Bytes_Out);

      Panel_Elements.Box_Sides (3, P'Access, Bytes_Out);

      Panel_Elements.Text_Line (4, P'Access, V.Intro, Bytes_Out);

      Panel_Elements.Box_Sides (5, P'Access, Bytes_Out);

      for J in 1 .. 10 loop
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 2 * J + 4);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
         P.Append (Bytes_Out, " ");
         P.Append (Bytes_Out, Natural'Wide_Image (J));
         P.Append (Bytes_Out, " ");
         P.Append (Bytes_Out,
            Lines.To_Wide_String (V.Option_Labels (J)));
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 2 * J + 4);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

         Panel_Elements.Box_Sides (2 * J + 5, P'Access, Bytes_Out);

      end loop;

      for J in 26 .. 38 loop
         Panel_Elements.Box_Sides (J, P'Access, Bytes_Out);
      end loop;

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 39);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Highlighted);
      P.Append (Bytes_Out, Lines.To_Wide_String (V.Subtitle));
      P.Append (Bytes_Out, " ==>");
      IBM_3270_Orders.Start_Field (Bytes_Out, False, Normal_Text);
      IBM_3270_Orders.Insert_Cursor (Bytes_Out);
      if V.Option = 0 then
         P.Append (Bytes_Out, "    ");
      else
         --
         --  Ought to make this fixed width
         --
         P.Append (Bytes_Out, Natural'Wide_Image (V.Option));
         P.Append (Bytes_Out, "   ");
      end if;
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 39);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

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
      V : in out Numbered_Menu_View;
      Bytes_In : Byte_Vectors.Vector) is
   begin

      Input_Stream.Parse (V, P'Access, Bytes_In);

   end From_Physical;

   procedure Update_AID (
      V : in out Numbered_Menu_View;
      AID : Buffer.Byte) is
   begin

      V.AID := AID;

   end Update_AID;

   procedure Update_Cursor (
      V : in out Numbered_Menu_View;
      X : Natural;
      Y : Natural) is
   begin

      null;

   end Update_Cursor;

   procedure Update_Field (
      V : in out Numbered_Menu_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String) is
   begin

      if Y = 39 then
         begin
            V.Option := Natural'Wide_Value (Lines.To_Wide_String (L));
         exception
            when others =>
               V.Option := 0;
         end;
      end if;

   end Update_Field;

   function Get_AID (V : Numbered_Menu_View) return Buffer.Byte is
   begin

      return V.AID;

   end Get_AID;

   procedure Set_Title (
      V : in out Numbered_Menu_View;
      L : Lines.Bounded_Wide_String) is
   begin

      V.Title := L;

   end Set_Title;

   procedure Prev_Page (V : in out Numbered_Menu_View) is
   begin

      null;

   end Prev_Page;

   procedure Next_Page (V : in out Numbered_Menu_View) is
   begin

      null;

   end Next_Page;

   procedure To_JSON (
      V : Numbered_Menu_View;
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

   end To_JSON;

   procedure Set_Label (
      V : in out Numbered_Menu_View;
      N : Natural;
      L : Lines.Bounded_Wide_String) is
   begin

      if N >= V.Option_Labels'First and N <= V.Option_Labels'Last then
         V.Option_Labels (N) := L;
      end if;

   end Set_Label;

   procedure Set_Intro (
      V : in out Numbered_Menu_View;
      L : Lines.Bounded_Wide_String) is
   begin

      V.Intro := L;

   end Set_Intro;

   function Get_Option (V : Numbered_Menu_View) return Natural is
   begin

      return V.Option;

   end Get_Option;

end Numbered_Menu_Views;
