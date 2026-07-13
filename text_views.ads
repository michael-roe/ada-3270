with Byte_Vectors;
with Views;
with Lines;

package Text_Views is

   type Text_View is new Views.View with null record;

   procedure To_Physical (
      V : Text_View;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure From_Physical (
      V : in out Text_View;
      Bytes_In : Byte_Vectors.Vector);

   procedure Update_Field (
      V : in out Text_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String);

end Text_Views;
