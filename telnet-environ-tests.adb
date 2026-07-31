package body Telnet.Environ.Tests is

   Example_Option : array (Integer range 1 .. 15) of Buffer.Byte := (
      16#27#, 16#0#, 16#3#, 16#43#,
      16#4F#, 16#44#, 16#45#, 16#50#,
      16#41#, 16#47#, 16#45#, 16#1#,
      16#35#, 16#30#, 16#30#);

   procedure Test_Parse (T : in out Test_Cases.Test_Case'Class) is
      Bytes_In : Byte_Vectors.Vector;
   begin

      for J in Example_Option'First .. Example_Option'Last loop
         Bytes_In.Append (Example_Option (J));
      end loop;

      Parse (Bytes_In);

   end Test_Parse;

   procedure Register_Tests (T : in out Environ_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Parse'Access,
         "Test_Parse");

   end Register_Tests;

   function Name (T : Environ_Test) return Message_String is
   begin
      return Format ("Telnet.Environ.Tests");
   end Name;

end Telnet.Environ.Tests;
