with Buffer;

package Telnet.Terminal is

   --
   --  Defined in RFC 1091, TELNET Terminal Type Option
   --

   Is_Cmd : constant Buffer.Byte := 0; --  "is" is a reserved word in Ada

   Send : constant Buffer.Byte := 1;

end Telnet.Terminal;
