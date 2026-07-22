with Buffer;
with Views;
with Lines;
with Byte_Vectors;
with Pageable_Views;

package Paged_Views is

   type Paged_View is abstract new Views.View and
      Pageable_Views.Pageable_View with null record;

   procedure To_Physical (
      V : Paged_View;
      Bytes_Out : in out Byte_Vectors.Vector) is abstract;

   procedure From_Physical (
      V : in out Paged_View;
      Bytes_In : Byte_Vectors.Vector) is abstract;

   procedure Update_AID (
      V : in out Paged_View;
      AID : Buffer.Byte) is abstract;

   procedure Update_Field (
      V : in out Paged_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String) is abstract;

   procedure Prev_Page (V : in out Paged_View) is abstract;

   procedure Next_Page (V : in out Paged_View) is abstract;

end Paged_Views;
