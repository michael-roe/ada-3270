with Ada.Characters.Latin_1;
with Ada.Characters.Handling;
with Ada.Characters.Conversions;
with Ada.Containers; use type Ada.Containers.Count_Type;
with AUnit.Assertions; use AUnit.Assertions;
with Buffer;
use type Buffer.Byte;
with Code_Page_310;
with IBM_3270;

package body Code_Page_924.Tests is

   P : Code_Page_924.Page_924;

   subtype Seven_Bit is Buffer.Byte range 0 .. 127;

   procedure Test_Round_Trip (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
   begin

      for J in Wide_Character'Val (16#20#) .. Wide_Character'Val (16#7F#) loop
         P.Append (V, "" & J);
      end loop;

      Assert (V.Length = 128 - 32, "Length should be 95");

      for J in V.First_Index .. V.Last_Index loop
         Assert (P.To_Wide_Character (V.Element (J)) =
            Wide_Character'Val (J + 16#20#),
            "Round-trip conversion of character");
      end loop;

   end Test_Round_Trip;

   procedure Test_Round_Trip_2 (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
   begin

      P.Append (V, "" & Wide_Character'Val (16#152#));

      Assert (V.Length = 1, "Length should be 1");
      Assert (P.To_Wide_Character (V (0)) = Wide_Character'Val (16#152#),
         "Character should survive round trip");

   end Test_Round_Trip_2;

   procedure Register_Tests (T : in out Code_Page_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Round_Trip'Access,
         "Test_Round_Trip");

      Register_Routine (T, Test_Round_Trip'Access,
         "Test_Round_Trip2");

   end Register_Tests;

   function Name (T : Code_Page_Test) return Test_String is
   begin
      return Format ("Code_Page_924.Tests");
   end Name;

end Code_Page_924.Tests;
