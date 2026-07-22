with Buffer;
with Byte_Vectors;
with Views;
with Lines;

package Checkbox_Views is

   type Checkbox_Array is array (1 .. 4) of Boolean;

   type Checkbox_View is new Views.View with record
      AID : Buffer.Byte := 0;
      Checkboxes : Checkbox_Array;
   end record;

   procedure To_Physical (
      V : Checkbox_View;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure From_Physical (
      V : in out Checkbox_View;
      Bytes_In : Byte_Vectors.Vector);

   procedure Update_AID (
      V : in out Checkbox_View;
      AID : Buffer.Byte);

   procedure Update_Cursor (
      V : in out Checkbox_View;
      X : Natural;
      Y : Natural);

   procedure Update_Field (
      V : in out Checkbox_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String);

end Checkbox_Views;
