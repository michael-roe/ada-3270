with AUnit.Run;
with AUnit.Reporter.Text;
with My_Fuzzers;

procedure Fuzz_Runner is
   procedure Run is new AUnit.Run.Test_Runner (My_Fuzzers.Suite);
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin

   Run (Reporter);

end Fuzz_Runner;
