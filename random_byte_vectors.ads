with Byte_Vectors;
with Random_Bytes;

package Random_Byte_Vectors is

   procedure Random (
      V : in out Byte_Vectors.Vector;
      Gen : in Random_Bytes.Generator);

end Random_Byte_Vectors;
