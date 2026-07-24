with Buffer;
with Byte_Vectors;

package Code_Pages is

   type Code_Page is abstract tagged null record;

   procedure Append (
      P : Code_Page;
      V : in out Byte_Vectors.Vector;
      S : Wide_String) is abstract;

   function To_Wide_Character (
      P : Code_Page;
      B : Buffer.Byte) return Wide_Character is abstract;

end Code_Pages;
