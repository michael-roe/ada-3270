with Ada.Text_IO;
with Ada.Containers;
use type Ada.Containers.Count_Type;
with Code_Page_310;
with Code_Page_500;
with Box_Drawing;
with IBM_3270_Orders;
--  use type IBM_3270_Orders.Intensity;
with Input_Stream;

package body Text_Views is

   function Normal_Text return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Normal_Text;

   procedure To_Physical (
      V : Text_View;
      Bytes_Out : in out Byte_Vectors.Vector) is
      B : Byte_Vectors.Vector;
      Line_Number : Natural;
   begin

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Down_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Down_Left);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      Code_Page_500.Append (Bytes_Out, " Text Input Panel Test");
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 1);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Left);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 69, 3);
      Code_Page_500.Append (Bytes_Out, "More: ");
      if V.Page_Number <= Natural (V.Text.Length) / 36 then
         Code_Page_500.Append (Bytes_Out, "+");
      else
         Code_Page_500.Append (Bytes_Out, " ");
      end if;
      Code_Page_500.Append (Bytes_Out, " ");
      if V.Page_Number = 0 then
         Code_Page_500.Append (Bytes_Out, " ");
      else
         Code_Page_500.Append (Bytes_Out, "-");
      end if;
      Code_Page_500.Append (Bytes_Out, " ");
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      for J in 4 .. 39 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
         IBM_3270_Orders.Start_Field (Bytes_Out, False, Normal_Text);
         if J = 4 then
            IBM_3270_Orders.Insert_Cursor (Bytes_Out);
         end if;
         Line_Number := 36 * V.Page_Number + J - 4;
         if Line_Number <= V.Text.Last_Index then
            Code_Page_500.Append (
               Bytes_Out,
               Lines.To_Wide_String (V.Text (Line_Number)));
         end if;
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 78, J);
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      end loop;

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 40);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Left);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      Code_Page_500.Append (Bytes_Out, " PF1=Help");
      Code_Page_500.Append (Bytes_Out, " PF3=Exit");
      Code_Page_500.Append (Bytes_Out, " PF7=Prev");
      Code_Page_500.Append (Bytes_Out, " PF8=Next");
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 41);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 42);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Up_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Up_Left);

   end To_Physical;

   procedure From_Physical (
      V : in out Text_View;
      Bytes_In : Byte_Vectors.Vector) is
   begin

      Input_Stream.Parse (V, Bytes_In);

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

   procedure Prev_Page (V : in out Text_View) is
   begin

      Ada.Text_IO.Put ("Prev_Page");
      Ada.Text_IO.New_Line;
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

end Text_Views;
