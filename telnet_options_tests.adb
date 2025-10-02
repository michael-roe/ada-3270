with AUnit.Assertions; use AUnit.Assertions;
with Telnet.Options;
with Telnet.Negotiation; use type Telnet.Negotiation.Do_Dont;

package body Telnet_Options_Tests is

   procedure Test_Will (T : in out Test_Cases.Test_Case'Class) is
      Reply : Telnet.Negotiation.Do_Dont;
   begin
      Telnet.Negotiation.Will (Telnet.Options.Transmit_Binary, Reply);
      Assert (Reply = Telnet.Negotiation.Send_Do_It,
         "DO expected in response to WILL");
      null;
   end Test_Will;

   procedure Register_Tests (T : in out Telnet_Options_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Will'Access,
         "Test_Will");

   end Register_Tests;

   function Name (T : Telnet_Options_Test) return Message_String is
   begin
      return Format ("Telnet_Options_Tests");
   end Name;

end Telnet_Options_Tests;
