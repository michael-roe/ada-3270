with Ada.Wide_Text_IO;
with Ada.Characters.Handling;
with Ada.Containers;
use type Ada.Containers.Count_Type;
with Ada.Characters.Latin_1;
with Ada.Characters.Conversions;
with AUnit.Assertions; use AUnit.Assertions;
with Buffer;
use type Buffer.Byte;
with Arrows;
with Block_Elements;
with Box_Drawing;
with Math_Operators;
with Byte_Vectors;
with Byte_Text_IO;

package body Code_Page_310.Tests is

   procedure Test_National_Variants (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
      S : Wide_String := "[\]{|}~";
   begin

      for J in S'Range loop
         Code_Page_310.Append (V, S (J));
      end loop;

      Assert (V.Length = 14, "Length should be 14");
      Assert (Code_Page_310.To_Wide_Character (V.Element (1)) = '[',
         "[ should survive round trip");
      Assert (Code_Page_310.To_Wide_Character (V.Element (3)) = '\',
         "\ should survive round trip");
      Assert (Code_Page_310.To_Wide_Character (V.Element (5)) = ']',
         "] should survive round trip");
      Assert (Code_Page_310.To_Wide_Character (V.Element (7)) = '{',
         "{ should survive round trip");
      Assert (Code_Page_310.To_Wide_Character (V.Element (9)) = '|' or
         Code_Page_310.To_Wide_Character (V.Element (9)) =
         Wide_Character'Val (16#2223#),
         "| should survive round trip");
      Assert (Code_Page_310.To_Wide_Character (V.Element (11)) = '}',
         "} should survive round trip");
      Assert (Code_Page_310.To_Wide_Character (V.Element (13)) = '~' or
         Code_Page_310.To_Wide_Character (V.Element (13)) =
         Wide_Character'Val (16#223c#),
         "~ should survive round trip");

   end Test_National_Variants;

   procedure Test_Section_Sign (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
      Section_Sign : Wide_Character;
      Paragraph_Sign : Wide_Character;
   begin

      Section_Sign := Ada.Characters.Conversions.To_Wide_Character (
        Ada.Characters.Latin_1.Section_Sign);

      Paragraph_Sign := Ada.Characters.Conversions.To_Wide_Character (
         Ada.Characters.Latin_1.Paragraph_Sign);

      Code_Page_310.Append (V, Section_Sign);

      Code_Page_310.Append (V, Paragraph_Sign);

      Assert (V.Length = 4, "Length should be 4");

      Assert (Code_Page_310.To_Wide_Character (V.Element (1)) =
         Section_Sign,
         "Section sign should survive round trip");

      Assert (Code_Page_310.To_Wide_Character (V.Element (3)) =
         Paragraph_Sign,
         "Paragraph sign should survive round trip");

   end Test_Section_Sign;

   procedure Test_Box_Drawing (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
   begin

      Code_Page_310.Append (V, Box_Drawing.Down_Right);
      Code_Page_310.Append (V, Box_Drawing.Down_Left);
      Code_Page_310.Append (V, Box_Drawing.Up_Right);
      Code_Page_310.Append (V, Box_Drawing.Up_Left);
      Code_Page_310.Append (V, Box_Drawing.Horizontal);
      Code_Page_310.Append (V, Box_Drawing.Vertical);

      Assert (Code_Page_310.To_Wide_Character (V.Element (V.First_Index + 1))
         = Box_Drawing.Down_Right,
         "Down Right");

      Assert (Code_Page_310.To_Wide_Character (V.Element (V.First_Index + 3))
         = Box_Drawing.Down_Left,
         "Down Left");

      Assert (Code_Page_310.To_Wide_Character (V.Element (V.First_Index + 5))
         = Box_Drawing.Up_Right,
         "Up Right");

      Assert (Code_Page_310.To_Wide_Character (V.Element (V.First_Index + 7))
         = Box_Drawing.Up_Left,
         "Up Left");

      Assert (Code_Page_310.To_Wide_Character (V.Element (V.First_Index + 9))
         = Box_Drawing.Horizontal,
         "Horizontal");

      Assert (Code_Page_310.To_Wide_Character (V.Element (V.First_Index + 11))
         = Box_Drawing.Vertical,
         "Vertical");

   end Test_Box_Drawing;

   procedure Test_Block_Elements (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
   begin

      Code_Page_310.Append (V, Block_Elements.Upper_Half);
      Code_Page_310.Append (V, Block_Elements.Lower_Half);
      Code_Page_310.Append (V, Block_Elements.Left_Half);
      Code_Page_310.Append (V, Block_Elements.Right_Half);

      Assert (V.Length = 8, "Length should be 8");

   end Test_Block_Elements;

   procedure Test_Arrows (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
   begin

      Code_Page_310.Append (V, Arrows.Leftwards_Arrow);
      Code_Page_310.Append (V, Arrows.Rightwards_Arrow);
      Code_Page_310.Append (V, Arrows.Upwards_Arrow);
      Code_Page_310.Append (V, Arrows.Downwards_Arrow);

      Assert (V.Length = 8, "Length should be 8");

   end Test_Arrows;

   procedure Test_Math_Operators (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
      Multiplication_Sign : Wide_Character;
      Division_Sign : Wide_Character;
   begin

      Multiplication_Sign := Ada.Characters.Conversions.To_Wide_Character (
         Ada.Characters.Latin_1.Multiplication_Sign);

      Division_Sign := Ada.Characters.Conversions.To_Wide_Character (
         Ada.Characters.Latin_1.Division_Sign);

      Code_Page_310.Append (V, Multiplication_Sign);
      Code_Page_310.Append (V, Division_Sign);
      Code_Page_310.Append (V, Math_Operators.Less_Than_Or_Equal);
      Code_Page_310.Append (V, Math_Operators.Greater_Than_Or_Equal);
      Code_Page_310.Append (V, Math_Operators.Not_Equal);

      Assert (V.Length = 10, "Length should be 10");

   end Test_Math_Operators;

   procedure Test_Invalid (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
   begin

      Code_Page_310.Append (V, Wide_Character'Val (16#101#));

      Assert (V.Length = 0, "Length should be 0");

   end Test_Invalid;

   procedure Register_Tests (T : in out Code_Page_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_National_Variants'Access,
         "Test_National_Variants");

      Register_Routine (T, Test_Section_Sign'Access,
         "Test_Section_Sign");

      Register_Routine (T, Test_Box_Drawing'Access,
         "Test_Box_Drawing");

      Register_Routine (T, Test_Block_Elements'Access,
         "Test_Block_Elements");

      Register_Routine (T, Test_Arrows'Access,
         "Test_Arrows");

      Register_Routine (T, Test_Math_Operators'Access,
         "Test_Math_Operators");

      Register_Routine (T, Test_Invalid'Access,
         "Test_Invalid");

   end Register_Tests;

   function Name (T : Code_Page_Test) return Test_String is
   begin
      return Format ("Code_Page_310_Tests");
   end Name;

end Code_Page_310.Tests;
