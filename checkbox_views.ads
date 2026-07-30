with Buffer;
with Byte_Vectors;
with Views;
with Lines;

package Checkbox_Views is

   type Checkbox_Array is array (1 .. 18) of Boolean;

   type Label_Array is array (1 .. 18) of Lines.Bounded_Wide_String;

   type Checkbox_View is new Views.View with private;

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

   function Get_AID (V : Checkbox_View) return Buffer.Byte;

   procedure Set_Title (
      V : in out Checkbox_View;
      L : Lines.Bounded_Wide_String);

   procedure Set_Label (
      V : in out Checkbox_View;
      N : Natural;
      L : Lines.Bounded_Wide_String);

   procedure Set_Checkbox (
      V : in out Checkbox_View;
      N : Natural;
      Ticked : Boolean);

private

   type Checkbox_View is new Views.View with record
      AID : Buffer.Byte := 0;
      Title : Lines.Bounded_Wide_String;
      Labels : Label_Array;
      Checkboxes : Checkbox_Array;
      Last_Item : Natural := 1;
   end record;

end Checkbox_Views;
