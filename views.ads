with Buffer;
with Byte_Vectors;
with Lines;

package Views is

   type View is abstract tagged null record;

   procedure To_Physical (
      V : View;
      Bytes_Out : in out Byte_Vectors.Vector) is abstract;

   procedure From_Physical (
      V : in out View;
      Bytes_In : Byte_Vectors.Vector) is abstract;

   procedure Update_AID (
      V : in out View;
      AID : Buffer.Byte) is abstract;

   procedure Update_Cursor (
      V : in out View;
      X : Natural;
      Y : Natural) is abstract;

   procedure Update_Field (
      V : in out View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String) is abstract;

   function Get_AID (V : View) return Buffer.Byte is abstract;

   type View_Access is access all View'Class;

end Views;
