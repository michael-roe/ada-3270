with Code_Pages;
with Buffer;
with Byte_Vectors;

package Code_Page_880 is

   type Page_880 is new Code_Pages.Code_Page with null record;

   procedure Append (
      P : Page_880;
      V : in out Byte_Vectors.Vector;
      S : Wide_String);

   function To_Wide_Character (
      P : Page_880;
      B : Buffer.Byte) return Wide_Character;

end Code_Page_880;
