with Buffer;

package Telnet.Negotiation is

   type Will_Wont is (Send_Wont, Send_Nothing, Send_Will);

   type Do_Dont is (Send_Dont, Send_Nothing, Send_Do_It);

   procedure Will (Option : Buffer.Byte; Reply : out Do_Dont);

   procedure Wont (Option : Buffer.Byte; Reply : out Do_Dont);

   procedure Request_Enable (Option : Buffer.Byte; Reply : out Do_Dont);

   procedure Do_It (Option : Buffer.Byte; Reply : out Will_Wont);

   procedure Dont (Option : Buffer.Byte; Reply : out Will_Wont);

end Telnet.Negotiation;
