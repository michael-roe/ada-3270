with Ada.Text_IO;
with Ada.Wide_Text_IO;
with Ada.Characters.Handling;
with Ada.Containers; use type Ada.Containers.Count_Type;
with AUnit.Assertions; use AUnit.Assertions;
with Buffer;
use type Buffer.Byte;
with Math_Operators;
with IBM_3270;

package body Code_Page_875.Tests is

   P : Code_Page_875.Page_875;

   procedure Test_Round_Trip (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
   begin

      for J in Wide_Character'Val (16#20#) .. Wide_Character'Val (16#7e#) loop
         P.Append (V, "" & J);
      end loop;

      for J in V.First_Index .. V.Last_Index loop
         Assert (P.To_Wide_Character (V.Element (J)) =
            Wide_Character'Val (J + 16#20#),
            "Round-trip conversion of character");
      end loop;

   end Test_Round_Trip;

   procedure Test_Round_Trip2 (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
   begin

      for J in Wide_Character'Val (16#A1#) .. Wide_Character'Val (16#FF#) loop
         P.Append (V, "" & J);
      end loop;

      Assert (V.Length = 128 - 33, "Length should be 95");

      for J in V.First_Index .. V.Last_Index loop
         Assert (P.To_Wide_Character (V.Element (J)) =
            Wide_Character'Val (J + 16#A1#),
            "Round-trip conversion of character");
      end loop;

   end Test_Round_Trip2;

   procedure Test_Graphic_Escape (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
   begin

      P.Append (V, "" & Math_Operators.Logical_And);

      Assert (V.Length = 2, "Length should be 2");
      Assert (V.Element (V.First_Index) = IBM_3270.Graphic_Escape,
        "Should start with Graphic_Escape");

   end Test_Graphic_Escape;

   procedure Register_Tests (T : in out Code_Page_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Round_Trip'Access,
         "Test_Round_Trip");

--      Register_Routine (T, Test_Round_Trip2'Access,
--         "Test_Round_Trip2");

   end Register_Tests;

   function Name (T : Code_Page_Test) return Test_String is
   begin
      return Format ("Code_Page_875.Tests");
   end Name;

end Code_Page_875.Tests;
