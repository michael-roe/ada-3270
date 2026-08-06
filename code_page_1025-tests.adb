with Ada.Characters.Handling;
with Ada.Containers; use type Ada.Containers.Count_Type;
with AUnit.Assertions; use AUnit.Assertions;
with Buffer;
use type Buffer.Byte;

package body Code_Page_1025.Tests is

   P : Code_Page_1025.Page_1025;

   subtype Seven_Bit is Buffer.Byte range 0 .. 127;

   procedure Test_Round_Trip (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
   begin

      for J in Wide_Character'Val (16#20#) .. Wide_Character'Val (16#7E#) loop
         P.Append (V, "" & J);
      end loop;

      Assert (V.Length = 127 - 32, "Length should be 94");

      for J in V.First_Index .. V.Last_Index loop
         Assert (P.To_Wide_Character (V.Element (J)) =
            Wide_Character'Val (J + 16#20#),
            "Round-trip conversion of character" & Integer'Image (J + 16#20#));
      end loop;

   end Test_Round_Trip;

   procedure Test_Round_Trip2 (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
   begin

      null;

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
      return Format ("Code_Page_1025.Tests");
   end Name;

end Code_Page_1025.Tests;
