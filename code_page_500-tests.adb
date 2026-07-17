with Ada.Wide_Text_IO;
with Ada.Characters.Handling;
with AUnit.Assertions; use AUnit.Assertions;
with Buffer;
use type Buffer.Byte;

package body Code_Page_500.Tests is

   procedure Test_Round_Trip (T : in out Test_Cases.Test_Case'Class) is

      V : Byte_Vectors.Vector;

   begin

      for J in Wide_Character'Val (16#40#) .. Wide_Character'Val (16#7F#) loop
         Code_Page_500.Append (V, "" & J);
      end loop;

      for J in V.First_Index .. V.Last_Index loop
         Assert (To_Wide_Character (V.Element (J)) =
            Wide_Character'Val (J + 16#40#),
            "Round-trip conversion of character");
      end loop;

   end Test_Round_Trip;

   procedure Test_Round_Trip2 (T : in out Test_Cases.Test_Case'Class) is

      V : Byte_Vectors.Vector;

   begin

      for J in Wide_Character'Val (16#A1#) .. Wide_Character'Val (16#FF#) loop
         Code_Page_500.Append (V, "" & J);
      end loop;

      for J in V.First_Index .. V.Last_Index loop
         Assert (To_Wide_Character (V.Element (J)) =
            Wide_Character'Val (J + 16#A1#),
            "Round-trip conversion of character");
      end loop;

   end Test_Round_Trip2;

   procedure Register_Tests (T : in out Code_Page_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Round_Trip'Access,
         "Test_Round_Trip");

      Register_Routine (T, Test_Round_Trip2'Access,
         "Test_Round_Trip2");

   end Register_Tests;

   function Name (T : Code_Page_Test) return Test_String is
   begin
      return Format ("Code_Page_500_Tests");
   end Name;

end Code_Page_500.Tests;
