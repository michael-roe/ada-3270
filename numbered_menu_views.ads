with Byte_Vectors;
with Views;
with Lines;

package Numbered_Menu_Views is

   type Numbered_Menu_View is new Views.View with null record;

   procedure To_Physical (
      V : Numbered_Menu_View;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure From_Physical (
      V : in out Numbered_Menu_View;
      Bytes_In : Byte_Vectors.Vector);

   procedure Update_Cursor (
      V : in out Numbered_Menu_View;
      X : Natural;
      Y : Natural);

   procedure Update_Field (
      V : in out Numbered_Menu_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String);

end Numbered_Menu_Views;
