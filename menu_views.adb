with Code_Page_310;
with Code_Page_500;
with Box_Drawing;
with IBM_3270_Orders;
with Byte_Text_IO;

package body Menu_Views is

   function Normal_Text return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Normal_Text;

   function Highlighted return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Highlighted;

   procedure To_Physical (
      V : Menu_View;
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

      for J in 1 .. 4 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 2 * J + 1);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Highlighted);
         Code_Page_310.Append (Bytes_Out, '[');
         IBM_3270_Orders.Start_Field (Bytes_Out,
            False,
            IBM_3270_Orders.Detectable);
         if J = 1 then
            IBM_3270_Orders.Insert_Cursor (Bytes_Out);
         end if;
         Code_Page_500.Append (Bytes_Out, " ");
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Highlighted);
         Code_Page_310.Append (Bytes_Out, ']');
         Code_Page_500.Append (Bytes_Out, " Option");
         Code_Page_500.Append (Bytes_Out, Natural'Wide_Image (J));
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 78, 2 * J + 2);
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      end loop;

   end To_Physical;

   procedure From_Physical (
      V : in out Menu_View;
      Bytes_In : Byte_Vectors.Vector) is
   begin

      null;

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

      null;

   end Update_Cursor;

   procedure Update_Field (
      V : in out Menu_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String) is
   begin
      null;
   end Update_Field;

end Menu_Views;
