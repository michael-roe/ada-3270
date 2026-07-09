with Code_Page_310;
with Code_Page_500;
with Box_Drawing;
with IBM_3270_Orders;
with Byte_Text_IO;

package body Split_Views is

   function Normal_Text return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Normal_Text;

   procedure To_Physical (
      V : Split_View;
      Bytes_Out : in out Byte_Vectors.Vector) is
      B : Byte_Vectors.Vector;
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
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 78, 3);
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      for J in 4 .. 19 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 78, J);
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      end loop;

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      -- IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 20);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Left);

      for J in 21 .. 39 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
         IBM_3270_Orders.Start_Field (Bytes_Out, False, Normal_Text);
         if J = 21 then
            IBM_3270_Orders.Insert_Cursor (Bytes_Out);
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
      Code_Page_500.Append (Bytes_Out, " PF7=Prev PF8=Next");
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
      V : Split_View;
      Bytes_In : Byte_Vectors.Vector) is
   begin

      null;

   end From_Physical;

end Split_Views;
