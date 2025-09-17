with Buffer_Suite;
with AUnit.Run;
with AUnit.Reporter.Text;

procedure Buffer_Runner is
   procedure Run is new AUnit.Run.Test_Runner (Buffer_Suite.Suite);
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Run (Reporter);
end Buffer_Runner;

