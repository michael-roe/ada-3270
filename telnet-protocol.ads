with Buffer; use type Buffer.Byte;

package Telnet.Protocol is

   --
   --  Defined in RFC 854, TELNET Protocol Specification
   --

   SE   : constant Buffer.Byte := 240;
   NOP  : constant Buffer.Byte := 241;
   BRK  : constant Buffer.Byte := 243;
   IP   : constant Buffer.Byte := 244;
   GA   : constant Buffer.Byte := 249;
   SB   : constant Buffer.Byte := 250;
   WILL : constant Buffer.Byte := 251;
   WONT : constant Buffer.Byte := 252;
   DOIT : constant Buffer.Byte := 253; --  DO is a reserved word in Ada
   DONT : constant Buffer.Byte := 254;
   IAC  : constant Buffer.Byte := 255;

   --
   --  Defined in RFC 885, TELNET End of Record Option
   --

   EOR  : constant Buffer.Byte := 239;

end Telnet.Protocol;
