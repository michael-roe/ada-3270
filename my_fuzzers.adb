with AUnit.Test_Suites;
with IBM_3270.Input_Stream.Fuzzers;

package body My_Fuzzers is

   Result : aliased AUnit.Test_Suites.Test_Suite;

   Fuzzer_1 : aliased IBM_3270.Input_Stream.Fuzzers.Input_Stream_Fuzzer;

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
   begin

      AUnit.Test_Suites.Add_Test (Result'Access, Fuzzer_1'Access);

      return Result'Access;

   end Suite;
 
end My_Fuzzers;
