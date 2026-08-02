with Buffer;
with Byte_Vectors;

package Code_Page_UTF8 is

   procedure Append (V : in out Byte_Vectors.Vector;
      C : Wide_Character);

end Code_Page_UTF8;
