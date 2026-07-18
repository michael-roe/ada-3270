with Ada.Wide_Text_IO;
with Ada.Characters.Handling;
with AUnit.Assertions; use AUnit.Assertions;
with Buffer;
use type Buffer.Byte;
with Box_Drawing;
with Byte_Vectors;
with Byte_Text_IO;

package body Code_Page_310.Tests is

   procedure Test_Round_Trip (T : in out Test_Cases.Test_Case'Class) is

      V : Byte_Vectors.Vector;

   begin

      Code_Page_310.Append (V, Box_Drawing.Down_Right);
      Code_Page_310.Append (V, Box_Drawing.Down_Left);
      Code_Page_310.Append (V, Box_Drawing.Up_Right);
      Code_Page_310.Append (V, Box_Drawing.Up_Left);

      Assert (Code_Page_310.To_Wide_Character (V.Element (V.First_Index + 1))
         = Box_Drawing.Down_Right,
         "Round trip");

      Assert (Code_Page_310.To_Wide_Character (V.Element (V.First_Index + 3))
         = Box_Drawing.Down_Left,
         "Round trip");

      Assert (Code_Page_310.To_Wide_Character (V.Element (V.First_Index + 5))
         = Box_Drawing.Up_Right,
         "Round trip");

      Assert (Code_Page_310.To_Wide_Character (V.Element (V.First_Index + 7))
         = Box_Drawing.Up_Left,
         "Round trip");

   end Test_Round_Trip;

   procedure Register_Tests (T : in out Code_Page_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Round_Trip'Access,
         "Test_Round_Trip");

   end Register_Tests;

   function Name (T : Code_Page_Test) return Test_String is
   begin
      return Format ("Code_Page_310_Tests");
   end Name;

end Code_Page_310.Tests;
