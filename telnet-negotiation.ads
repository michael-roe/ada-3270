with Buffer;

package Telnet.Negotiation is

   type Will_Wont is (Send_Wont, Send_Nothing, Send_Will);

   type Do_Dont is (Send_Dont, Send_Nothing, Send_Do_It);

   type Request_Offer is (Request, Offer, Done);

   function Is_Enabled (Option : Buffer.Byte) return Boolean;

   --  Is_Enabled returns True if the option is enabled at this end

   function Is_Peer_Enabled (Option : Buffer.Byte) return Boolean;

   --  Is_Peer_Enabled returns True if the peer has confirmed that
   --  the option is enabled.

   procedure Request_Enable (Option : Buffer.Byte; Reply : out Do_Dont);

   --  Request_Enables asks the peer to enable the option.
   --  The peer can decline.
   --
   --  Precondition: not Is_Peer_Enabled (Option)

   procedure Request_Disable (Option : Buffer.Byte; Reply : out Do_Dont);

   --  Request_Disable asks the peer to disable the option.

   procedure Offer_Enable (Option : Buffer.Byte; Reply : out Will_Wont);

   --  Offer_Enables makes an offer to peer to enable the option.
   --  The peer can decline the offer.

   procedure Disable (Option : Buffer.Byte; Reply : out Will_Wont);

   --  Disable disables the option and notifies the peer that it has
   --  been disabled.

   procedure Will (Option : Buffer.Byte; Reply : out Do_Dont);

   --  Will processes an incoming WILL message

   procedure Wont (Option : Buffer.Byte; Reply : out Do_Dont);

   --  Wont processes an incoming WONT message

   procedure Do_It (Option : Buffer.Byte; Reply : out Will_Wont);

   --  Do_It processes an incoming DO message

   procedure Dont (Option : Buffer.Byte; Reply : out Will_Wont);

   --  Dont processes an incoming DONT message

   procedure Next_Option
      (Direction : out Request_Offer;
       Option    : out Buffer.Byte);

end Telnet.Negotiation;
