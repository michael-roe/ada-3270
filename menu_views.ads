with Buffer;
with Byte_Vectors;
with Views;
with Lines;

package Menu_Views is

   type Menu_View is new Views.View with record
      AID : Buffer.Byte;
   end record;

   procedure To_Physical (
      V : Menu_View;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure From_Physical (
      V : in out Menu_View;
      Bytes_In : Byte_Vectors.Vector);

   procedure Update_AID (
      V : in out Menu_View;
      AID : Buffer.Byte);

   procedure Update_Cursor (
      V : in out Menu_View;
      X : Natural;
      Y : Natural);

   procedure Update_Field (
      V : in out Menu_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String);

end Menu_Views;
