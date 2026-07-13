with Byte_Vectors;
with Views;

package Text_Views is

   type Text_View is new Views.View with null record;

   procedure To_Physical (
      V : Text_View;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure From_Physical (
      V : in out Text_View;
      Bytes_In : Byte_Vectors.Vector);

end Text_Views;
