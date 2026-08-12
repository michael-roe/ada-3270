with Code_Pages;
with Buffer;
with Byte_Vectors;

package Code_Page_924 is

   type Page_924 is new Code_Pages.Code_Page with null record;

   procedure Append (
      P : Page_924;
      V : in out Byte_Vectors.Vector;
      S : Wide_String);

   function To_Wide_Character (
      P : Page_924;
      B : Buffer.Byte) return Wide_Character;

end Code_Page_924;
