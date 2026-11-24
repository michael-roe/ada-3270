with Code_Pages;
with Buffer;
with Byte_Vectors;

package Code_Page_037 is

   type Page_037 is new Code_Pages.Code_Page with null record;

   procedure Append (
      P : Page_037;
      V : in out Byte_Vectors.Vector;
      S : Wide_String);

   function To_Wide_Character (
      P : Page_037;
      B : Buffer.Byte) return Wide_Character;

end Code_Page_037;
