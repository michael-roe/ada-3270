with AUnit.Assertions; use AUnit.Assertions;
with Ada.Containers; use type Ada.Containers.Count_Type;
with Byte_Text_IO;
with Buffer;
use type Buffer.Byte;
with Lines;
with Line_Vectors;

package body Code_Page_UTF8.Tests is

   procedure Test_One_Byte (T : in out AUnit.Test_Cases.Test_Case'Class) is
      Bytes_Out : Byte_Vectors.Vector;
   begin

      Code_Page_UTF8.Append (Bytes_Out, 'A');

      Assert (Bytes_Out.Length = 1, "Length should be 1");
      Assert (Bytes_Out.Element (Bytes_Out.First_Index) =
         Character'Pos ('A'),
         "Character should be encoded as itself");

   end Test_One_Byte;

   procedure Test_Two_Bytes (T : in out AUnit.Test_Cases.Test_Case'Class) is
      Bytes_Out : Byte_Vectors.Vector;
   begin

      Code_Page_UTF8.Append (Bytes_Out, Wide_Character'Val (16#A7#));

      Assert (Bytes_Out.Length = 2, "Length should be 2");
      Assert (Bytes_Out.Element (Bytes_Out.First_Index) = 16#C2#,
         "First byte should be #16#C2");
      Assert (Bytes_Out.Element (Bytes_Out.First_Index + 1) = 16#A7#,
         "First byte should be #16#A7");

   end Test_Two_Bytes;

   procedure Register_Tests (T : in out UTF8_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_One_Byte'Access,
         "Test_One_Byte");

      Register_Routine (T, Test_Two_Bytes'Access,
         "Test_Two_Bytes");

   end Register_Tests;

   function Name (T : UTF8_Test) return AUnit.Message_String is
   begin
      return AUnit.Format ("Code_Page_UTF8.Tests");
   end Name;

end Code_Page_UTF8.Tests;
