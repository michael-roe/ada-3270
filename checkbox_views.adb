with Ada.Text_IO;
with Ada.Wide_Text_IO;
with Code_Page_310;
with Code_Page_500;
with Box_Drawing;
with IBM_3270_Orders;
with Input_Stream;
with Byte_Text_IO;
with Lines;

package body Checkbox_Views is

   function Normal_Text return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Normal_Text;

   procedure CallBack (X : Integer; Y : Integer; L : Lines.Bounded_Wide_String) is
   begin
      Ada.Text_IO.Put ("Field = (");
      Ada.Text_IO.Put (Natural'Image (X));
      Ada.Text_IO.Put (",");
      Ada.Text_IO.Put (Natural'Image (Y));
      Ada.Text_IO.Put (",");
      Ada.Wide_Text_IO.Put (Lines.To_Wide_String (L));
      Ada.Text_IO.Put (")");
      Ada.Text_IO.New_Line;
   end Callback;

   procedure Parse is new Input_Stream.Parse (Callback => Callback);

   procedure To_Physical (
      V : Checkbox_View;
      Bytes_Out : in out Byte_Vectors.Vector) is
      B : Byte_Vectors.Vector;
   begin
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      Code_Page_310.Append (Bytes_Out, '[');
      IBM_3270_Orders.Start_Field (Bytes_Out,
         False,
         IBM_3270_Orders.Detectable);
      IBM_3270_Orders.Insert_Cursor (Bytes_Out);
      Code_Page_500.Append (Bytes_Out, "?");
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      Code_Page_310.Append (Bytes_Out, ']');

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 1);
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      Code_Page_310.Append (Bytes_Out, '[');
      IBM_3270_Orders.Start_Field (Bytes_Out,
         False,
         IBM_3270_Orders.Detectable,
         Modified => True);
      Code_Page_500.Append (Bytes_Out, ">");
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      Code_Page_310.Append (Bytes_Out, ']');

   end To_Physical;

   procedure From_Physical (
      V : Checkbox_View;
      Bytes_In : Byte_Vectors.Vector) is
   begin
      Parse (Bytes_In);
   end From_Physical;

end Checkbox_Views;

