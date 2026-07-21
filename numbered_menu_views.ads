with Byte_Vectors;
with Paged_Views;
with Lines;

package Numbered_Menu_Views is

   type Label_Array is array (1 .. 10) of Lines.Bounded_Wide_String;

   type Numbered_Menu_View is new Paged_Views.Paged_View with record
      Option : Natural;
      Option_Labels : Label_Array;
   end record;

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

   procedure Prev_Page (V : in out Numbered_Menu_View);

   procedure Next_Page (V : in out Numbered_Menu_View);

   procedure Set_Label (
      V : in out Numbered_Menu_View;
      N : Natural;
      L : Lines.Bounded_Wide_String);

end Numbered_Menu_Views;
