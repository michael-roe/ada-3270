with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package Telnet.Environ.Tests is

   type Environ_Test is new Test_Cases.Test_Case with null record;

   procedure Test_Parse (T : in out Test_Cases.Test_Case'Class);

   procedure Register_Tests (T : in out Environ_Test);

   function Name (T : Environ_Test) return Message_String;

end Telnet.Environ.Tests;
