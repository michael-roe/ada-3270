with Code_Page_310;
with Code_Page_500;
with Box_Drawing;
with IBM_3270;
with IBM_3270_Orders;
with Input_Stream;
with Ada.Text_IO;
with Ada.Wide_Text_IO;
with Byte_Text_IO;
with Buffer;
use type Buffer.Byte;
with Lines;

package body Login_Views is

   function Normal_Text return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Normal_Text;

   function Highlighted return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Highlighted;

   function Hidden return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Hidden;

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
      V : Login_View;
      Bytes_Out : in out Byte_Vectors.Vector) is
      B : Byte_Vectors.Vector;
   begin

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Down_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Down_Left);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      Code_Page_500.Append (Bytes_Out, " Login");
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

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Highlighted);
      Code_Page_500.Append (Bytes_Out, "User Name");
      IBM_3270_Orders.Start_Field (Bytes_Out, False, Normal_Text);
      IBM_3270_Orders.Insert_Cursor (Bytes_Out);
      Code_Page_500.Append (Bytes_Out, "            ");
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 4);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 5);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Highlighted);
      Code_Page_500.Append (Bytes_Out, "Password ");
      IBM_3270_Orders.Start_Field (Bytes_Out, False, Hidden);
      Code_Page_500.Append (Bytes_Out, "            ");
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 6);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

   end To_Physical;

   procedure From_Physical (
      V : Login_View;
      Bytes_In : Byte_Vectors.Vector) is
   begin
      Parse (Bytes_In);
   end From_Physical;

end Login_Views;

