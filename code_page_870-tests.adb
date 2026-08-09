with Ada.Characters.Latin_1;
with Ada.Characters.Handling;
with Ada.Characters.Conversions;
with Ada.Containers; use type Ada.Containers.Count_Type;
with AUnit.Assertions; use AUnit.Assertions;
with Buffer;
use type Buffer.Byte;
with Code_Page_310;
with IBM_3270;

package body Code_Page_870.Tests is

   P : Code_Page_870.Page_870;

   subtype Seven_Bit is Buffer.Byte range 0 .. 127;

   Not_ASCII : array (Seven_Bit) of Wide_Character := (
Wide_Character'Val (16#0080#),
Wide_Character'Val (16#0081#),
Wide_Character'Val (16#0082#),
Wide_Character'Val (16#0083#),
Wide_Character'Val (16#0084#),
Wide_Character'Val (16#0085#),
Wide_Character'Val (16#0086#),
Wide_Character'Val (16#0087#),
Wide_Character'Val (16#0088#),
Wide_Character'Val (16#0089#),
Wide_Character'Val (16#008a#),
Wide_Character'Val (16#008b#),
Wide_Character'Val (16#008c#),
Wide_Character'Val (16#008d#),
Wide_Character'Val (16#008e#),
Wide_Character'Val (16#008f#),
Wide_Character'Val (16#0090#),
Wide_Character'Val (16#0091#),
Wide_Character'Val (16#0092#),
Wide_Character'Val (16#0093#),
Wide_Character'Val (16#0094#),
Wide_Character'Val (16#0095#),
Wide_Character'Val (16#0096#),
Wide_Character'Val (16#0097#),
Wide_Character'Val (16#0098#),
Wide_Character'Val (16#0099#),
Wide_Character'Val (16#009a#),
Wide_Character'Val (16#009b#),
Wide_Character'Val (16#009c#),
Wide_Character'Val (16#009d#),
Wide_Character'Val (16#009e#),
Wide_Character'Val (16#009f#),
Wide_Character'Val (16#00a0#),
Wide_Character'Val (16#00a4#),
Wide_Character'Val (16#00a7#),
Wide_Character'Val (16#00a8#),
Wide_Character'Val (16#00ad#),
Wide_Character'Val (16#00b0#),
Wide_Character'Val (16#00b4#),
Wide_Character'Val (16#00b7#),
Wide_Character'Val (16#00b8#),
Wide_Character'Val (16#00c1#),
Wide_Character'Val (16#00c2#),
Wide_Character'Val (16#00c4#),
Wide_Character'Val (16#00c7#),
Wide_Character'Val (16#00c9#),
Wide_Character'Val (16#00cb#),
Wide_Character'Val (16#00cd#),
Wide_Character'Val (16#00ce#),
Wide_Character'Val (16#00d3#),
Wide_Character'Val (16#00d4#),
Wide_Character'Val (16#00d6#),
Wide_Character'Val (16#00d7#),
Wide_Character'Val (16#00da#),
Wide_Character'Val (16#00dc#),
Wide_Character'Val (16#00dd#),
Wide_Character'Val (16#00df#),
Wide_Character'Val (16#00e1#),
Wide_Character'Val (16#00e2#),
Wide_Character'Val (16#00e4#),
Wide_Character'Val (16#00e7#),
Wide_Character'Val (16#00e9#),
Wide_Character'Val (16#00eb#),
Wide_Character'Val (16#00ed#),
Wide_Character'Val (16#00ee#),
Wide_Character'Val (16#00f3#),
Wide_Character'Val (16#00f4#),
Wide_Character'Val (16#00f6#),
Wide_Character'Val (16#00f7#),
Wide_Character'Val (16#00fa#),
Wide_Character'Val (16#00fc#),
Wide_Character'Val (16#00fd#),
Wide_Character'Val (16#0102#),
Wide_Character'Val (16#0103#),
Wide_Character'Val (16#0104#),
Wide_Character'Val (16#0105#),
Wide_Character'Val (16#0106#),
Wide_Character'Val (16#0107#),
Wide_Character'Val (16#010c#),
Wide_Character'Val (16#010d#),
Wide_Character'Val (16#010e#),
Wide_Character'Val (16#010f#),
Wide_Character'Val (16#0110#),
Wide_Character'Val (16#0111#),
Wide_Character'Val (16#0118#),
Wide_Character'Val (16#0119#),
Wide_Character'Val (16#011a#),
Wide_Character'Val (16#011b#),
Wide_Character'Val (16#0139#),
Wide_Character'Val (16#013a#),
Wide_Character'Val (16#013d#),
Wide_Character'Val (16#013e#),
Wide_Character'Val (16#0141#),
Wide_Character'Val (16#0142#),
Wide_Character'Val (16#0143#),
Wide_Character'Val (16#0144#),
Wide_Character'Val (16#0147#),
Wide_Character'Val (16#0148#),
Wide_Character'Val (16#0150#),
Wide_Character'Val (16#0151#),
Wide_Character'Val (16#0154#),
Wide_Character'Val (16#0155#),
Wide_Character'Val (16#0158#),
Wide_Character'Val (16#0159#),
Wide_Character'Val (16#015a#),
Wide_Character'Val (16#015b#),
Wide_Character'Val (16#015e#),
Wide_Character'Val (16#015f#),
Wide_Character'Val (16#0160#),
Wide_Character'Val (16#0161#),
Wide_Character'Val (16#0162#),
Wide_Character'Val (16#0163#),
Wide_Character'Val (16#0164#),
Wide_Character'Val (16#0165#),
Wide_Character'Val (16#016e#),
Wide_Character'Val (16#016f#),
Wide_Character'Val (16#0170#),
Wide_Character'Val (16#0171#),
Wide_Character'Val (16#0179#),
Wide_Character'Val (16#017a#),
Wide_Character'Val (16#017b#),
Wide_Character'Val (16#017c#),
Wide_Character'Val (16#017d#),
Wide_Character'Val (16#017e#),
Wide_Character'Val (16#02c7#),
Wide_Character'Val (16#02d8#),
Wide_Character'Val (16#02db#),
Wide_Character'Val (16#02dd#));

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

   procedure Test_Round_Trip2 (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
   begin

      for J in Not_ASCII'Range loop
         P.Append (V, "" & Not_ASCII (J));
      end loop;

      Assert (V.Length = 128, "Length should be 128");

      for J in V.First_Index .. V.Last_Index loop
         Assert (P.To_Wide_Character (V.Element (J)) =
            Not_ASCII (Seven_Bit (J)),
            "Round-trip conversion of character");
      end loop;

   end Test_Round_Trip2;

   procedure Test_Superscripts (T : in out Test_Cases.Test_Case'Class) is
      V : Byte_Vectors.Vector;
      Superscript_One : Wide_Character;
      Superscript_Two : Wide_Character;
      Superscript_Three : Wide_Character;
   begin

      --
      --  Superscript_One is in ISO Latin 1 but not in ISO Latin 2,
      --  and it is in Code Page 310, so it should be represented using
      --  a Graphics Escape.
      --

      Superscript_One := Ada.Characters.Conversions.To_Wide_Character (
         Ada.Characters.Latin_1.Superscript_One);

      P.Append (V, "" & Superscript_One);

      Assert (V.Length = 2, "Length should be 2");

      Assert (V.Element (0) = IBM_3270.Graphic_Escape,
        "Should start with Graphic Escape");

      Assert (Code_Page_310.To_Wide_Character (V.Element (1)) =
         Superscript_One,
         "Superscript_One should survive round trip");

   end Test_Superscripts;

   procedure Register_Tests (T : in out Code_Page_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Round_Trip'Access,
         "Test_Round_Trip");

      Register_Routine (T, Test_Round_Trip2'Access,
         "Test_Round_Trip2");

      Register_Routine (T, Test_Superscripts'Access,
         "Test_Superscripts");

   end Register_Tests;

   function Name (T : Code_Page_Test) return Test_String is
   begin
      return Format ("Code_Page_870.Tests");
   end Name;

end Code_Page_870.Tests;
