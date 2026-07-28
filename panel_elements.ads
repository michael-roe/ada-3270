with Byte_Vectors;
with Code_Pages;
with Lines;

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

   procedure Box_Sides (
      Y : Natural;
      P : Code_Pages.Code_Page_Access;
      Bytes_Out : in out Byte_Vectors.Vector);

   --
   --  Box_Sides draws the left and right vertical edges of a box at
   --  line Y on the screen.
   --

   procedure Left_Box_Side (
      Y : Natural;
      P : Code_Pages.Code_Page_Access;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure Left_Input_Label (
      Y : Natural;
      P : Code_Pages.Code_Page_Access;
      Field_Name : Lines.Bounded_Wide_String;
      Bytes_Out : in out Byte_Vectors.Vector);
      
   procedure Right_Scroll_Up_Down (
      Y : Natural;
      P : Code_Pages.Code_Page_Access;
      Prev_Enabled : Boolean;
      Next_Enabled : Boolean;
      Bytes_Out : in out Byte_Vectors.Vector);

end Panel_Elements;
