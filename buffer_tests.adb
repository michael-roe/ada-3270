with AUnit.Assertions; use AUnit.Assertions;
with Buffer; use Buffer;

package body Buffer_Tests is

  procedure Test_Clear(T: in out Test_Cases.Test_Case'Class) is
    Buff: Buffer.T;
    empty: Boolean;
    full: Boolean;
  begin
    Clear(Buff);
    empty := Is_Empty(Buff);
    Assert(empty, "Buffer not empty after Clear");
    full := Is_Full(Buff);
    Assert(not full, "Buffer full after Clear");
  end Test_Clear;

  procedure Register_Tests (T: in out Buffer_Test) is
    use AUnit.Test_Cases.Registration;
  begin
    Register_Routine(T, Test_Clear'Access, "Test_Clear");
  end Register_Tests;

  function Name(T: Buffer_Test) return Test_String is
  begin
    return Format("Buffer_Tests");
  end Name;

end Buffer_Tests;
