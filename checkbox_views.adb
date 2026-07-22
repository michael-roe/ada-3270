with Ada.Text_IO;
with Ada.Wide_Text_IO;
with Buffer;
use type Buffer.Byte;
with Code_Page_310;
with Code_Page_500;
with Box_Drawing;
with IBM_3270;
with IBM_3270_Orders;
with Input_Stream;
with Byte_Text_IO;

package body Checkbox_Views is

   function Normal_Text return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Normal_Text;

   function Highlighted return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Highlighted;

   procedure To_Physical (
      V : Checkbox_View;
      Bytes_Out : in out Byte_Vectors.Vector) is
      B : Byte_Vectors.Vector;
   begin

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Down_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Down_Left);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      Code_Page_500.Append (Bytes_Out, " Checkbox Test");
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

         if V.Checkboxes (J) then
            IBM_3270_Orders.Start_Field (Bytes_Out,
               False,
               IBM_3270_Orders.Detectable,
               Modified => True);
         else
            IBM_3270_Orders.Start_Field (Bytes_Out,
               False,
               IBM_3270_Orders.Detectable);
         end if;

         if J = 1 then
            IBM_3270_Orders.Insert_Cursor (Bytes_Out);
         end if;

         if V.Checkboxes (J) then
            Code_Page_500.Append (Bytes_Out, ">");
         else
            Code_Page_500.Append (Bytes_Out, "?");
         end if;

         IBM_3270_Orders.Start_Field (Bytes_Out, True, Highlighted);
         Code_Page_310.Append (Bytes_Out, ']');
         Code_Page_500.Append (Bytes_Out, " Box ");
         Code_Page_500.Append (Bytes_Out, Natural'Wide_Image (J));
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 2 * J + 2);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      end loop;

   end To_Physical;

   procedure From_Physical (
      V : in out Checkbox_View;
      Bytes_In : Byte_Vectors.Vector) is
      AID : Buffer.Byte;
   begin

      --  Ought to check there is a first element
      AID := Bytes_In.Element (Bytes_In.First_Index);
      if not IBM_3270_Orders.Is_Short_Read (AID) then
         for J in 1 .. 4 loop
            V.Checkboxes (J) := False;
         end loop;
         Input_Stream.Parse (V, Bytes_In);
      end if;

   end From_Physical;

   procedure Update_AID (
      V : in out Checkbox_View;
      AID : Buffer.Byte) is
   begin

      V.AID := AID; 
   
   end Update_AID;

   procedure Update_Cursor (
      V : in out Checkbox_View;
      X : Natural;
      Y : Natural) is
   begin

      null;

   end Update_Cursor;

   procedure Update_Field (
      V : in out Checkbox_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String) is
      F : Natural;
   begin

      if (X = 4) and (Y >= 4) and (Y <= 10) and (Y mod 2 = 0) then
         F := (Y - 4) / 2 + 1;
         Ada.Text_IO.Put ("Updating field ");
         Ada.Text_IO.Put (Natural'Image (F));
         Ada.Text_IO.New_Line;
         V.Checkboxes (F) := True;
      end if;

   end Update_Field;

end Checkbox_Views;
