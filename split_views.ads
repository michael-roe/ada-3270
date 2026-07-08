with Byte_Vectors;
with Views;

package Split_Views is

   type Split_View is new Views.View with null record;

   procedure To_Physical (
      V : Split_View;
       Bytes_Out : in out Byte_Vectors.Vector);

end Split_Views;
