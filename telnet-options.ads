with Buffer; use type Buffer.Byte;

package Telnet.Options is

   --
   --  Defined by RFC 856, TELNET Binary Transmission
   --

   Transmit_Binary : constant Buffer.Byte := 0;

   --
   --  Defined by RFC 858, TELNET Supress Go Ahead Option
   --

   Supress_Go_Ahead : constant Buffer.Byte := 3;

   --
   --  Defined by RFC 1091, TELNET Terminal-Type Option
   --

   Terminal_Type : constant Buffer.Byte := 24;

   --
   --  Defined by RFC 885, TELNET End of Record Option
   --

   End_Of_Record : constant Buffer.Byte := 25;

   --
   --  Defined by RFC 1572, TELNET Environment Option
   --

   New_Environ : constant Buffer.Byte := 39;

end Telnet.Options;
