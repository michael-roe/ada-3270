with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package Telnet_Options_Tests is

   type Telnet_Options_Test is new Test_Cases.Test_Case with null record;

   procedure Register_Tests (T : in out Telnet_Options_Test);

   function Name (T : Telnet_Options_Test) return Message_String;

   procedure Test_Will (T : in out Test_Cases.Test_Case'Class);

end Telnet_Options_Tests;
