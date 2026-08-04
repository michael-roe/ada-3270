with Ada.Characters.Handling;
with Ada.Containers; use type Ada.Containers.Count_Type;
with AUnit.Assertions; use AUnit.Assertions;
with Ada.Text_IO;
with Ada.Wide_Text_IO;
with Buffer;
use type Buffer.Byte;

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

   procedure Register_Tests (T : in out Code_Page_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_ASCII'Access,
         "Test_ASCII");

   end Register_Tests;

   function Name (T : Code_Page_Test) return Test_String is
   begin
      return Format ("Code_Page_880.Tests");
   end Name;

end Code_Page_880.Tests;
