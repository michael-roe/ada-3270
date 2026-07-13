with Byte_Vectors;
with Views;

package Checkbox_Views is

   type Checkbox_Array is array (1 .. 4) of Boolean;

   type Checkbox_View is new Views.View with record
      Checkboxes : Checkbox_Array;
   end record;

   procedure To_Physical (
      V : Checkbox_View;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure From_Physical (
      V : in out Checkbox_View;
      Bytes_In : Byte_Vectors.Vector);
      
end Checkbox_Views;
