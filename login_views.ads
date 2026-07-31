with Buffer;
with Byte_Vectors;
with Views;
with Lines;

package Login_Views is

   type Login_View is new Views.View with private;

   procedure To_Physical (
      V : Login_View;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure From_Physical (
      V : in out Login_View;
      Bytes_In : Byte_Vectors.Vector);

   procedure Update_AID (
      V : in out Login_View;
      AID : Buffer.Byte);

   procedure Update_Cursor (
      V : in out Login_View;
      X : Natural;
      Y : Natural);

   procedure Update_Field (
      V : in out Login_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String);

   function Get_AID (V : Login_View) return Buffer.Byte;

   procedure Set_Title (
      V : in out Login_View;
      L : Lines.Bounded_Wide_String);

private

   type Login_View is new Views.View with record
      AID : Buffer.Byte;
      Title : Lines.Bounded_Wide_String;
   end record;

end Login_Views;
