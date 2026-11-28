package body IBM_3270.Input_Stream.Fuzzers is

   procedure Fuzz_Parser (T : in out AUnit.Test_Cases.Test_Case'Class) is
   begin

      null;

   end Fuzz_Parser;

   procedure Register_Tests (T : in out Input_Stream_Fuzzer) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Fuzz_Parser'Access,
         "Fuzz_Parser");

   end Register_Tests;

   function Name (T : Input_Stream_Fuzzer) return Message_String is
   begin

      return Format ("IBM_3270.Input_Stream.Fuzzers");

   end Name;

end IBM_3270.Input_Stream.Fuzzers;
