with Byte_Vectors;
with Views;

package Checkbox_Views is

   type Checkbox_View is new Views.View with null record;

   procedure To_Physical (
      V : Checkbox_View;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure From_Physical (
      V : Checkbox_View;
      Bytes_In : Byte_Vectors.Vector);
      
end Checkbox_Views;
