with Byte_Vectors;
with Paged_Views;
with Buffer;
with Lines;
with Line_Vectors;

package Text_Views is

   type Text_View is new Paged_Views.Paged_View with record
      AID : Buffer.Byte := 0;
      Page_Number : Natural := 0;
      Text : Line_Vectors.Vector;
   end record;

   procedure To_Physical (
      V : Text_View;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure From_Physical (
      V : in out Text_View;
      Bytes_In : Byte_Vectors.Vector);

   procedure Update_AID (
      V : in out Text_View;
      AID : Buffer.Byte);

   procedure Update_Cursor (
      V : in out Text_View;
      X : Natural;
      Y : Natural);

   procedure Update_Field (
      V : in out Text_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String);

   function Get_AID (V : Text_View) return Buffer.Byte;

   procedure Prev_Page (V : in out Text_View);

   procedure Next_Page (V : in out Text_View);

end Text_Views;
