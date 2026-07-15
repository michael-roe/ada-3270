with Ada.Text_IO;
with Ada.Wide_Text_IO;
with Code_Page_310;
with Code_Page_500;
with Box_Drawing;
with IBM_3270_Orders;
with Byte_Text_IO;
with Input_Stream;
with Ada.Containers;
use type Ada.Containers.Count_Type;

package body Split_Views is

   function Normal_Text return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Normal_Text;

   procedure To_Physical (
      V : Split_View;
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
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 1);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Left);
       
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 70, 3);
      Code_Page_500.Append (Bytes_Out, "More: +");
      if V.Page_Number = 0 then
         Code_Page_500.Append (Bytes_Out, " ");
      else
         Code_Page_500.Append (Bytes_Out, "-");
      end if;
      Code_Page_500.Append (Bytes_Out, " ");
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      for J in 4 .. 19 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
         Line_Number := J - 4 + 16*V.Page_Number;
         if Line_Number <= V.History.Last_Index then
            Code_Page_500.Append (
               Bytes_Out,
               Lines.To_Wide_String (V.History (Line_Number)));
         end if;
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 78, J);
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      end loop;

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Left);

      for J in 21 .. 39 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
         IBM_3270_Orders.Start_Field (Bytes_Out, False, Normal_Text);
         if J = 21 then
            IBM_3270_Orders.Insert_Cursor (Bytes_Out);
         end if;
         Code_Page_500.Append (
            Bytes_Out,
            Lines.To_Wide_String (V.Edit (J - 21)));
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
      Code_Page_500.Append (Bytes_Out, " PF3=Exit PF7=Prev PF8=Next");
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
      V : in out Split_View;
      Bytes_In : Byte_Vectors.Vector) is
   begin
      Input_Stream.Parse (V, Bytes_In);
   end From_Physical;

   procedure Update_Field (
      V : in out Split_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String) is
   begin
      Ada.Text_IO.Put ("(");
      Ada.Text_IO.Put (Natural'Image (X));
      Ada.Text_IO.Put (", ");
      Ada.Text_IO.Put (Natural'Image (Y));
      Ada.Text_IO.Put (", ");
      Ada.Wide_Text_IO.Put (Lines.To_Wide_String (L));
      Ada.Text_IO.Put (")");
      Ada.Text_IO.New_Line;

      V.Edit (Y - 21) := L;

   end Update_Field;

   procedure Prev_Page (V : in out Split_View) is
   begin

      Ada.Text_IO.Put ("Prev_Page");
      Ada.Text_IO.New_Line;
      if V.Page_Number > 0 then
         V.Page_Number := V.Page_Number - 1;
      end if;

   end Prev_Page;

   procedure Next_Page (V : in out Split_View) is
   begin

      if V.Page_Number < Natural (V.History.Length/16) then
         V.Page_Number := V.Page_Number + 1;
      end if;

   end Next_Page;

end Split_Views;
