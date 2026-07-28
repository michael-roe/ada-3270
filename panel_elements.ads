with Byte_Vectors;
with Code_Pages;

package Panel_Elements is

   procedure Box_Top (
      Y : Natural;
      P : Code_Pages.Code_Page_Access;
      Bytes_Out : in out Byte_Vectors.Vector);

   --
   --  Box_Top draws the top line of a box at line Y of the screen.
   --  Y will usually be 0, the top line.
   --

   procedure Box_Bottom (
      Y : Natural;
      P : Code_Pages.Code_Page_Access;
      Bytes_Out : in out Byte_Vectors.Vector);

   --
   --  Box_Bottom draws the bottom line of a box at line Y of the screen.
   --  Y will usually be the last line of the screen.
   --

   procedure Horizontal_Rule (
      Y : Natural;
      P : Code_Pages.Code_Page_Access;
      Bytes_Out : in out Byte_Vectors.Vector);

   --
   --  Horizontal_Rule draws a horizontal rule and the left and right
   --  edges of a box at line Y on the screen.
   --

end Panel_Elements;
