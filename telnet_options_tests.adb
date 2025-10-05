with AUnit.Assertions; use AUnit.Assertions;
with Telnet.Options;
with Telnet.Negotiation; use type Telnet.Negotiation.Do_Dont;

package body Telnet_Options_Tests is

   procedure Test_Peer_Enables (T : in out Test_Cases.Test_Case'Class) is
      Reply : Telnet.Negotiation.Do_Dont;
   begin

      Telnet.Negotiation.Wont (Telnet.Options.Transmit_Binary, Reply);
      Assert (Reply = Telnet.Negotiation.Send_Nothing,
         "No reply expected in response to WONT");

      Assert (not Telnet.Negotiation.Is_Peer_Enabled
         (Telnet.Options.Transmit_Binary),
         "Peer status should be set to disabled at start of test");

      Telnet.Negotiation.Will (Telnet.Options.Transmit_Binary, Reply);
      Assert (Reply = Telnet.Negotiation.Send_Do_It,
         "DO expected in response to WILL");
      Assert (Telnet.Negotiation.Is_Peer_Enabled
         (Telnet.Options.Transmit_Binary),
         "Peer status should be set to enabled after receiving WILL");

      Telnet.Negotiation.Will (Telnet.Options.Transmit_Binary, Reply);
      Assert (Reply = Telnet.Negotiation.Send_Nothing,
         "No reply expected in response to second WILL");

      Telnet.Negotiation.Wont (Telnet.Options.Transmit_Binary, Reply);
      Assert (Reply = Telnet.Negotiation.Send_Dont,
         "DONT expected in response to WONT");
      Assert (not Telnet.Negotiation.Is_Peer_Enabled
         (Telnet.Options.Transmit_Binary),
         "Peer status should be set to disabled after receiving WONT");

   end Test_Peer_Enables;

   procedure Test_We_Enable (T : in out Test_Cases.Test_Case'Class) is
      Reply : Telnet.Negotiation.Do_Dont;
   begin

      Assert (not Telnet.Negotiation.Is_Peer_Enabled
         (Telnet.Options.End_Of_Record),
         "Peer status should be set to disabled at start of test");

      Telnet.Negotiation.Request_Enable (Telnet.Options.End_Of_Record, Reply);
      Assert (Reply = Telnet.Negotiation.Send_Do_It,
         "DO expected after Request_Enable");

      Telnet.Negotiation.Will (Telnet.Options.End_Of_Record, Reply);
      Assert (Reply = Telnet.Negotiation.Send_Nothing,
         "No reply expected in reply to WILL");
      Assert (Telnet.Negotiation.Is_Peer_Enabled
         (Telnet.Options.End_Of_Record),
         "Peer status should be set to enabled after receiving WILL");

      Telnet.Negotiation.Request_Disable (Telnet.Options.End_Of_Record, Reply);
      Assert (Reply = Telnet.Negotiation.Send_Dont,
         "DONT expected after Request_Disable");
      Assert (not Telnet.Negotiation.Is_Peer_Enabled
         (Telnet.Options.End_Of_Record),
         "Peer status should be set to disabled after Request_Disable");

      Telnet.Negotiation.Wont (Telnet.Options.End_Of_Record, Reply);
      Assert (Reply = Telnet.Negotiation.Send_Nothing,
         "No reply expected in reply to WONT");

   end Test_We_Enable;

   procedure Test_Queuing (T : in out Test_Cases.Test_Case'Class) is
      Reply : Telnet.Negotiation.Do_Dont;
   begin

      Assert (not Telnet.Negotiation.Is_Peer_Enabled
         (Telnet.Options.End_Of_Record),
         "Peer status should be set to disabled at start of test");

      Telnet.Negotiation.Request_Enable (Telnet.Options.End_Of_Record, Reply);
      Assert (Reply = Telnet.Negotiation.Send_Do_It,
         "DO expected after Request_Enable");

      Telnet.Negotiation.Request_Disable (Telnet.Options.End_Of_Record, Reply);
      Assert (Reply = Telnet.Negotiation.Send_Nothing,
         "No reply expected after queued Request_Disable");

      Telnet.Negotiation.Will (Telnet.Options.End_Of_Record, Reply);
      Assert (Reply = Telnet.Negotiation.Send_Dont,
         "Queued DONT expected in reply to WILL");

     Telnet.Negotiation.Wont (Telnet.Options.End_Of_Record, Reply);
      Assert (Reply = Telnet.Negotiation.Send_Nothing,
         "No reply expected in reply to WONT");

   end Test_Queuing;

   procedure Register_Tests (T : in out Telnet_Options_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Peer_Enables'Access,
         "Test_Peer_Enables");

      Register_Routine (T, Test_We_Enable'Access,
         "Test_We_Enable");

      Register_Routine (T, Test_Queuing'Access,
         "Test_Queuing");

   end Register_Tests;

   function Name (T : Telnet_Options_Test) return Message_String is
   begin
      return Format ("Telnet_Options_Tests");
   end Name;

end Telnet_Options_Tests;
