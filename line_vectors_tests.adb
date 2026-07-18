with AUnit.Assertions; use AUnit.Assertions;
with Ada.Containers; use type Ada.Containers.Count_Type;
with Lines;
with Line_Vectors;

package body Line_Vectors_Tests is

   procedure Test_Append (T : in out Test_Cases.Test_Case'Class) is

      L : Lines.Bounded_Wide_String;
      V : Line_Vectors.Vector;

   begin

      Lines.Set_Bounded_Wide_String (L, "Hello");

      Assert (Lines.Length (L) = 5,
         "Length of bounded string should be 5");

      V.Append (L);

      Assert (V.Length = 1,
         "Length of line vector should be 1");

   end Test_Append;

   procedure Register_Tests (T : in out Line_Vectors_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Append'Access,
         "Test_Append");

   end Register_Tests;

   function Name (T : Line_Vectors_Test) return Message_String is
   begin
      return Format ("Line_Vectors_Tests");
   end Name;

end Line_Vectors_Tests;
