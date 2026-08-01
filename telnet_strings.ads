with Ada.Strings.Bounded;

package Telnet_Strings is new Ada.Strings.Bounded.Generic_Bounded_Length
   (Max => 32);
