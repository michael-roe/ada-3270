with Byte_Vectors;
with Views;

package Login_Views is

   type Login_View is new Views.View with null record;

   procedure To_Physical (
      V : Login_View;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure From_Physical (
      V : Login_View;
      Bytes_In : Byte_Vectors.Vector);
      
end Login_Views;
