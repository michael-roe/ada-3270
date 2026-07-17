with Byte_Vectors;
with Views;
with Lines;

package Login_Views is

   type Login_View is new Views.View with null record;

   procedure To_Physical (
      V : Login_View;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure From_Physical (
      V : in out Login_View;
      Bytes_In : Byte_Vectors.Vector);

   procedure Update_Field (
      V : in out Login_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String);

end Login_Views;
