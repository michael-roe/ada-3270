with Byte_Vectors;
with Views;
with Lines;

package Split_Views is

   type Split_View is new Views.View with null record;

   procedure To_Physical (
      V : Split_View;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure From_Physical (
      V : in out Split_View;
      Bytes_In : Byte_Vectors.Vector);
      
   procedure Update_Field (
      V : in out Split_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String);

end Split_Views;
