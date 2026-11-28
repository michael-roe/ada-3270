with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package IBM_3270.Input_Stream.Fuzzers is

   type Input_Stream_Fuzzer is new Test_Cases.Test_Case with null record;

   procedure Register_Tests (T : in out Input_Stream_Fuzzer);

   function Name (T : Input_Stream_Fuzzer) return Message_String;

   procedure Fuzz_Parser (T : in out AUnit.Test_Cases.Test_Case'Class);

end IBM_3270.Input_Stream.Fuzzers;
