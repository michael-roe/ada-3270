with Ada.Text_IO; use Ada.Text_IO;
with Buffer;
with Telnet.Protocol;
with Telnet.Negotiation; use Telnet.Negotiation;

package body Telnet.Workers is

   task body Worker is
      C : Buffer.Byte;
      Direction : Telnet.Negotiation.Request_Offer;
      Option : Buffer.Byte;
   begin
      Next_Option (Direction, Option);

      TX.Enqueue (42);

         case Direction is
            when Offer =>
               Ada.Text_IO.Put_Line ("Offer");
               TX.Enqueue (Telnet.Protocol.IAC);
               TX.Enqueue (Telnet.Protocol.WILL);
               TX.Enqueue (Option);
            when Request =>
               Ada.Text_IO.Put_Line ("Request");
               TX.Enqueue (Telnet.Protocol.IAC);
               TX.Enqueue (Telnet.Protocol.DOIT);
               TX.Enqueue (Option);
            when Done =>
               Ada.Text_IO.Put_Line ("Negotiation done");
         end case;

      loop
         RX.Dequeue (C); Put (Buffer.Byte'Image (C));
      end loop;
   end Worker;

end Telnet.Workers;
