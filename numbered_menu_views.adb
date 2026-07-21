with Code_Page_310;
with Code_Page_500;
with Box_Drawing;
with IBM_3270_Orders;
with Byte_Text_IO;

package body Numbered_Menu_Views is

   function Normal_Text return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Normal_Text;

   function Highlighted return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Highlighted;

   procedure To_Physical (
      V : Numbered_Menu_View;
      Bytes_Out : in out Byte_Vectors.Vector) is
      B : Byte_Vectors.Vector;
   begin

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Down_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Down_Left);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      Code_Page_500.Append (Bytes_Out, " Menu Test");
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 1);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Left);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 3);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 4);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      Code_Page_500.Append (Bytes_Out, " Select an option and press Enter");
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 4);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 5);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 5);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      for J in 1 .. 10 loop
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 2 * J + 4);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
         Code_Page_500.Append (Bytes_Out, " ");
         Code_Page_500.Append (Bytes_Out, Natural'Wide_Image (J));
         Code_Page_500.Append (Bytes_Out, " Option");
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 2 * J + 4);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 2 * J + 5);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 2 * J + 5);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      end loop;

      for J in 26 .. 38 loop
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, J);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, J);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      end loop;

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 39);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Highlighted);
      Code_Page_500.Append (Bytes_Out, "Option ==>");
      IBM_3270_Orders.Start_Field (Bytes_Out, False, Normal_Text);
      IBM_3270_Orders.Insert_Cursor (Bytes_Out);
      Code_Page_500.Append (Bytes_Out, "    ");
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 39); 
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 40);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Left);

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 41);
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
      V : in out Numbered_Menu_View;
      Bytes_In : Byte_Vectors.Vector) is
   begin
      null;
   end From_Physical;

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
      null;
   end Update_Field;

end Numbered_Menu_Views;
