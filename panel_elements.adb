with Code_Page_310;
with Box_Drawing;
with IBM_3270_Orders;

package body Panel_Elements is

   function Normal_Text return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Normal_Text;

   function Highlighted return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Highlighted;

   procedure Box_Top (
      Y : Natural;
      P : Code_Pages.Code_Page_Access;
      Bytes_Out : in out Byte_Vectors.Vector) is
   begin

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, Y);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Down_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Down_Left);

   end Box_Top;

   procedure Box_Bottom (
      Y : Natural;
      P : Code_Pages.Code_Page_Access;
      Bytes_Out : in out Byte_Vectors.Vector) is
   begin

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, Y);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Up_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Up_Left);

   end Box_Bottom;

   procedure Horizontal_Rule (
      Y : Natural;
      P : Code_Pages.Code_Page_Access;
      Bytes_Out : in out Byte_Vectors.Vector) is
   begin

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, Y);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Left);

   end Horizontal_Rule;

   procedure Box_Sides (
      Y : Natural;
      P : Code_Pages.Code_Page_Access;
      Bytes_Out : in out Byte_Vectors.Vector) is
   begin

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, Y);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, Y);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

   end Box_Sides;

   procedure Left_Box_Side (
      Y : Natural;
      P : Code_Pages.Code_Page_Access;
      Bytes_Out : in out Byte_Vectors.Vector) is
   begin

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, Y);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

   end Left_Box_Side;

   procedure Left_Input_Label (
      Y : Natural;
      P : Code_Pages.Code_Page_Access; 
      Field_Name : Lines.Bounded_Wide_String;
      Bytes_Out : in out Byte_Vectors.Vector) is
   begin

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, Y);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      IBM_3270_Orders.Start_Field (Bytes_Out, True,  Highlighted);
      P.Append (Bytes_Out, Lines.To_Wide_String (Field_Name));
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);

   end Left_Input_Label;

   procedure Right_Scroll_Up_Down (
      Y : Natural;
      P : Code_Pages.Code_Page_Access;
      Prev_Enabled : Boolean;
      Next_Enabled : Boolean;
      Bytes_Out : in out Byte_Vectors.Vector) is
   begin

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 69, Y);
      P.Append (Bytes_Out, "More: ");
      if Next_Enabled then
         P.Append (Bytes_Out, "+");
      else
         P.Append (Bytes_Out, " ");
      end if;
      P.Append (Bytes_Out, " ");
      if Prev_Enabled then
         P.Append (Bytes_Out, "-");
      else
         P.Append (Bytes_Out, " ");
      end if;
      P.Append (Bytes_Out, " ");
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

   end Right_Scroll_Up_Down;

end Panel_Elements;
