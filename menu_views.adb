with Code_Page_310;
with Code_Page_500;
with Box_Drawing;
with IBM_3270_Orders;
with Byte_Text_IO;

package body Menu_Views is

   function Normal_Text return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Normal_Text;

   procedure To_Physical (
      V : Menu_View;
      Bytes_Out : in out Byte_Vectors.Vector) is
      B : Byte_Vectors.Vector;
   begin
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      Code_Page_310.Append (Bytes_Out, '[');
      IBM_3270_Orders.Start_Field (Bytes_Out,
         False,
         IBM_3270_Orders.Detectable);
      IBM_3270_Orders.Insert_Cursor (Bytes_Out);
      Code_Page_500.Append (Bytes_Out, " ");
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      Code_Page_310.Append (Bytes_Out, ']');

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 1);
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      Code_Page_310.Append (Bytes_Out, '[');
      IBM_3270_Orders.Start_Field (Bytes_Out,
         False,
         IBM_3270_Orders.Detectable);
      Code_Page_500.Append (Bytes_Out, " ");
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      Code_Page_310.Append (Bytes_Out, ']');

   end To_Physical;

   procedure From_Physical (
      V : in out Menu_View;
      Bytes_In : Byte_Vectors.Vector) is
   begin
      null;
   end From_Physical;

end Menu_Views;

