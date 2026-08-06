with Ada.Characters.Handling;
with Ada.Containers; use type Ada.Containers.Count_Type;
with AUnit.Assertions; use AUnit.Assertions;
with Ada.Text_IO;
with Ada.Wide_Text_IO;
with Ada.Integer_Text_IO;
with Buffer;
with Byte_Text_IO;
use type Buffer.Byte;
with Code_Page_310;
with IBM_3270;

package body Code_Page_880.Tests is

   P : Code_Page_880.Page_880;

   procedure Test_ASCII (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
   begin

      Assert (P.To_Wide_Character (16#40#) = ' ',
         "Conversion of 16#40# should be space");

      Assert (P.To_Wide_Character (16#4d#) = '(',
         "Conversion of 16#4d# should be '('");

      Assert (P.To_Wide_Character (16#81#) = 'a',
         "Conversion of 16#81# should be a");

      Assert (P.To_Wide_Character (16#c1#) = 'A',
         "Conversion of 16#c1# should be A");

   end Test_ASCII;

   procedure Test_Brackets (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
   begin

      P.Append (V, "{}");

      Assert (V.Length = 4, "Length should be 4");
      Assert (Code_Page_310.To_Wide_Character (V.Element (1)) = '{',
         "First character should be '{'");
      Assert (Code_Page_310.To_Wide_Character (V.Element (3)) = '}',
         "Second character should be '}'");

   end Test_Brackets;

   procedure Test_Tilde (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
      C : Wide_Character;
   begin

      P.Append (V, "~");

      Assert (V.Length = 2, "Length should be 2");

      C := Code_Page_310.To_Wide_Character (V.Element (1));

      Ada.Text_IO.Put ("Tilde -> ");
      Byte_Text_IO.Put (V.Element (0), Base => 16);
      Ada.Text_IO.Put ("->");
      Ada.Wide_Text_IO.Put (C);
      Ada.Integer_Text_IO.Put (Wide_Character'Pos (C), Base => 16);
      Ada.Text_IO.New_Line;
      Assert (C = Wide_Character'Val (16#223c#) or C = '~',
        "Tilde should round trip as tilde or tilde operator");

   end Test_Tilde;

   procedure Test_Bar (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
      C : Wide_Character;
   begin

      P.Append (V, "|");

      Assert (V.Length = 2, "Length should be 2");

      C := Code_Page_310.To_Wide_Character (V.Element (1));

      Ada.Text_IO.Put ("Bar -> ");
      Byte_Text_IO.Put (V.Element (0), Base => 16);
      Ada.Text_IO.Put ("->");
      Ada.Wide_Text_IO.Put (C);
      Ada.Integer_Text_IO.Put (Wide_Character'Pos (C), Base => 16);
      Ada.Text_IO.New_Line;

      Assert (C = Wide_Character'Val (16#2223#) or C = '|',
        "Bar should round trip as bar or divides by operator");

   end Test_Bar;

   procedure Test_Grave (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
      C : Wide_Character;
   begin

      P.Append (V, "`");

      Assert (V.Length = 0, "Length should be 0");

   end Test_Grave;

   procedure Test_Round_Trip (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
      C : Wide_Character;
   begin

      --
      --  Test that the printable Unicode characters up to U+7A, apart
      --  from grave accent, survive round trip via code page 880.
      --

      for J in Wide_Character'Val (16#20#) ..
         Wide_Character'Val (16#7a#)
      loop
         if J = '`' then
            P.Append (V, " ");
         else
            P.Append (V, "" & J);
         end if;
      end loop;

      Assert (V.Length = 91, "Length should be 91");

      for J in 0 .. 90 loop
         if J /= 16#40# then
            Assert (P.To_Wide_Character (V.Element (J)) =
               Wide_Character'Val (J + 16#20#),
               "Character did not survive round trip");
         end if;
      end loop;

   end Test_Round_Trip;

   procedure Register_Tests (T : in out Code_Page_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_ASCII'Access,
         "Test_ASCII");

      Register_Routine (T, Test_Brackets'Access,
         "Test_Brackets");

      Register_Routine (T, Test_Tilde'Access,
         "Test_Tilde");

      Register_Routine (T, Test_Bar'Access,
         "Test_Bar");

      Register_Routine (T, Test_Grave'Access,
         "Test_Grave");

      Register_Routine (T, Test_Round_Trip'Access,
         "Test_Round_Trip");

   end Register_Tests;

   function Name (T : Code_Page_Test) return Test_String is
   begin
      return Format ("Code_Page_880.Tests");
   end Name;

end Code_Page_880.Tests;
