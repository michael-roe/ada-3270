with Buffer;
--  use type Buffer.Byte;

package body Random_Byte_Vectors is

   procedure Random (
      V : in out Byte_Vectors.Vector;
      Gen : in Random_Bytes.Generator) is
      L : Buffer.Byte;
   begin

      L := Random_Bytes.Random (Gen);
      for J in 0 .. L loop
         V.Append (Random_Bytes.Random (Gen));
      end loop;

   end Random;

end Random_Byte_Vectors;
