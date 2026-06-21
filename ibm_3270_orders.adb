with IBM_3270;
with Buffer;
use type Buffer.Byte;

package body IBM_3270_Orders is

   procedure Insert_Cursor (V : in out Byte_Vectors.Vector) is
   begin
      V.Append (IBM_3270.Insert_Cursor);
   end Insert_Cursor;

   procedure Start_Field (V : in out Byte_Vectors.Vector;
      Protect : Boolean;
      Intense : Boolean) is
      Attr : Buffer.Byte;
   begin
      V.Append (IBM_3270.Start_Field);
      Attr := 0;
      if Protect then
         Attr := Attr + 16#20#;
      end if;
      if Intense then
         Attr := Attr + 16#08#;
      end if;
      V.Append (Attr);
   end Start_Field;

end IBM_3270_Orders;

