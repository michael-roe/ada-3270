with Buffer;
with Byte_Vectors;

package Code_Page_310 is

   procedure Append (V : in out Byte_Vectors.Vector; S : Wide_Character);

   function To_Wide_Character (B : Buffer.Byte) return Wide_Character;

end Code_Page_310;
