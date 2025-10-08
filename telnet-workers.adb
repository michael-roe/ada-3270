with Ada.Text_IO; use Ada.Text_IO;
with Buffer; use type Buffer.Byte;
with Telnet.Protocol;
with Telnet.Negotiation; use Telnet.Negotiation;

package body Telnet.Workers is

   type State is (Data, Data_IAC, Will, Wont, Do_It, Dont, Opt, Opt_IAC);

   task body Worker is
      S : State := Data;
      C : Buffer.Byte;
      Direction : Telnet.Negotiation.Request_Offer;
      Option : Buffer.Byte;
      WW : Telnet.Negotiation.Will_Wont;
      DD : Telnet.Negotiation.Do_Dont;
   begin

      for J in 1 .. 9 loop -- only 8 options to send

         Next_Option (Direction, Option);

         case Direction is
            when Offer =>
               Ada.Text_IO.Put_Line ("Offer");
               Telnet.Negotiation.Offer_Enable (Option, WW);
               case WW is
                  when Send_Nothing =>
                     null;
                  when Send_Wont =>
                     null;
                  when Send_Will =>
                     Ada.Text_IO.Put_Line ("Sending WILL");
                     TX.Enqueue (Telnet.Protocol.IAC);
                     TX.Enqueue (Telnet.Protocol.WILL);
                     TX.Enqueue (Option);
               end case;
            when Request =>
               Ada.Text_IO.Put_Line ("Request");
               Telnet.Negotiation.Request_Enable (Option, DD);
               case DD is
                  when Send_Nothing =>
                     null;
                  when Send_Dont =>
                     null;
                  when Send_Do_It =>
                     Ada.Text_IO.Put_Line ("Sending DO");
                     TX.Enqueue (Telnet.Protocol.IAC);
                     TX.Enqueue (Telnet.Protocol.DOIT);
                     TX.Enqueue (Option);
               end case;
            when Done =>
               Ada.Text_IO.Put_Line ("Negotiation done");
         end case;

      for K in 1 .. 3 loop
         RX.Dequeue (C);
         -- Put ("[");
         -- Put (Buffer.Byte'Image (C));
         -- Put ("]");
         case S is
            when Data =>
               if C = Telnet.Protocol.IAC then
                  Put ("[IAC]");
                  S := Data_IAC;
               else
                  Put ("[");
                  Ada.Text_IO.Put (Character'Val (C));
                  Put ("]");
               end if;  
            when Data_IAC =>
               case C is
                  when Telnet.Protocol.WILL =>
                     Put ("[WILL]");
                     S := Will;
                  when Telnet.Protocol.WONT =>
                     Put ("[WONT]");
                     S := Wont;
                  when Telnet.Protocol.DOIT =>
                     Put ("[DO]");
                     S := Do_It;
                  when Telnet.Protocol.DONT =>
                     Put ("[DONT]");
                     S := Dont;
                  when Telnet.Protocol.SB =>
                     Put ("[SB]");
                     S := Opt;
                  when Telnet.Protocol.BRK =>
                     Put ("[BREAK]");
                     S := Data;
                  when Telnet.Protocol.EOR =>
                     Put ("[EOR]");
                     S := Data;
                  when others =>
                     S := Data;
               end case;
            when Will =>
               Put ("[");
               Put (Buffer.Byte'Image (C));
               Put ("]");
               Telnet.Negotiation.Will (C, DD);
               if Telnet.Negotiation.Is_Peer_Enabled (C) then
                  Put_Line ("[Enabled]");
               end if;
               S := Data;
            when Do_It =>
               Put ("[");
               Put (Buffer.Byte'Image (C));
               Put ("]");
               Telnet.Negotiation.Do_It (C, WW);
               if Telnet.Negotiation.Is_Enabled (C) then
                  Put ("[Enabled]");
               end if;
               S := Data;
            when Wont =>
               Telnet.Negotiation.Wont (C, DD);
               S := Data;
            when Dont =>
               Telnet.Negotiation.Dont (C, WW);
               S := Data;
            when Opt =>
               if C = Telnet.Protocol.IAC then
                  S := Opt_IAC;
               else
                  Put ("[");
                  Put (Buffer.Byte'Image (C));
                  Put ("]");
               end if;
            when Opt_IAC =>
               if C = Telnet.Protocol.IAC then
                  Put ("[");
                  Put (Buffer.Byte'Image (C));
                  Put ("]");
                  S := Opt;
               elsif C = Telnet.Protocol.SE then
                  Put ("[SE]");
                  S := Data;
               else
                  S := Opt;
               end if;
            when others =>
               null;
         end case;
      end loop;
      end loop;
   end Worker;

end Telnet.Workers;
