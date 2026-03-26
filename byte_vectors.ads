with Ada.Containers.Vectors;
with Buffer;
use type Buffer.Byte;

package Byte_Vectors is new Ada.Containers.Vectors(
   Index_Type => Natural,
   Element_Type => Buffer.Byte);
