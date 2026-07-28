with Code_Page_310;
with Box_Drawing;
with IBM_3270_Orders;

package body Panel_Elements is

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

end Panel_Elements;
