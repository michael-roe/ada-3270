with Ada.Containers.Vectors;
with Lines;
use type Lines.Bounded_Wide_String;

package Line_Vectors is new Ada.Containers.Vectors (
   Index_Type => Natural,
   Element_Type => Lines.Bounded_Wide_String
);
