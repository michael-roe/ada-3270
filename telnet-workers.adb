with Ada.Text_IO; use Ada.Text_IO;
with Buffer; use type Buffer.Byte;
with Byte_Vectors;
with Byte_Text_IO;
with Telnet.Protocol;
with Telnet.Options;
with Telnet.Terminal;
with Telnet.Environ;
with Telnet.Negotiation; use Telnet.Negotiation;
with IBM_3270;

package body Telnet.Workers is

   type State is (Data, Data_IAC, Will, Wont, Do_It, Dont, Opt, Opt_IAC);

   Terminal_Message : Buffer.Byte_Array := (
      Telnet.Protocol.IAC,
      Telnet.Protocol.SB,
      Telnet.Options.Terminal_Type,
      Telnet.Terminal.Send,
      Telnet.Protocol.IAC,
      Telnet.Protocol.SE);

   Environ_Message : Buffer.Byte_Array := (
      Telnet.Protocol.IAC,
      Telnet.Protocol.SB,
      Telnet.Options.New_Environ,
      Telnet.Environ.Send_Cmd,
      Telnet.Environ.User_Var_Tag,
      Character'Pos ('C'),
      Character'Pos ('O'),
      Character'Pos ('D'),
      Character'Pos ('E'),
      Character'Pos ('P'),
      Character'Pos ('A'),
      Character'Pos ('G'),
      Character'Pos ('E'),
      Telnet.Protocol.IAC,
      Telnet.Protocol.SE);

   Screen_Message : Buffer.Byte_Array := (
      IBM_3270.IBM_Write_Erase,
      IBM_3270.WCC_Go_Ahead,
      IBM_3270.Graphic_Escape,
      16#C5#,
      Telnet.Protocol.IAC,
      Telnet.Protocol.EOR);

   task body Worker is
      S : State := Data;
      C : Buffer.Byte;
      Direction : Telnet.Negotiation.Request_Offer;
      Option : Buffer.Byte;
      WW : Telnet.Negotiation.Will_Wont;
      DD : Telnet.Negotiation.Do_Dont;
      Got_Reply : Boolean;
      Bytes_Out : Byte_Vectors.Vector;
      Bytes_In : Byte_Vectors.Vector;
      Option_In : Byte_Vectors.Vector;
      Environ_Sent : Boolean := False;
      Terminal_Sent : Boolean := False;
   begin

      for J in 1 .. 11 loop -- only 8 options to send

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
               if not Environ_Sent then
                  for J in Environ_Message'Range loop
                     TX.Enqueue (Environ_Message (J));
                  end loop;
                  Environ_Sent := True;
               elsif not Terminal_Sent then
                  for J in Terminal_Message'Range loop
                     TX.Enqueue (Terminal_Message (J));
                  end loop;
                  Terminal_Sent := True;
               else
                  for J in Screen_Message'Range loop
                     TX.Enqueue (Screen_Message (J));
                  end loop;
               end if;
         end case;

      Got_Reply := False;
      while not Got_Reply loop
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
                  Bytes_In.Append (C);
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
                     Got_Reply := True;
                  when Telnet.Protocol.EOR =>
                     Put ("[EOR]");
                     Put ("[Length = ");
                     Put (Bytes_In.Length'Image);
                     Put ("]");
                     Bytes_In.Clear;
                     S := Data;
                     Got_Reply := True;
                  when Telnet.Protocol.IAC =>
                     Bytes_In.Append (C);
                     Put ("[IAC]");
                     s := Data;
                  when others =>
                     S := Data;
               end case;
            when Will =>
               Put ("[");
               Byte_Text_IO.Put (C);
               Put ("]");
               Telnet.Negotiation.Will (C, DD);
               if Telnet.Negotiation.Is_Peer_Enabled (C) then
                  Put_Line ("[Enabled]");
               end if;
               S := Data;
               Got_Reply := True;
            when Do_It =>
               Put ("[");
               Byte_Text_IO.Put (C);
               Put ("]");
               Telnet.Negotiation.Do_It (C, WW);
               if Telnet.Negotiation.Is_Enabled (C) then
                  Put ("[Enabled]");
               end if;
               S := Data;
               Got_Reply := True;
            when Wont =>
               Telnet.Negotiation.Wont (C, DD);
               S := Data;
               Got_Reply := True;
            when Dont =>
               Telnet.Negotiation.Dont (C, WW);
               S := Data;
               Got_Reply := True;
            when Opt =>
               if C = Telnet.Protocol.IAC then
                  S := Opt_IAC;
               else
                  Option_In.Append (C);
                  if C < 32 then
                     Put ("[");
                     Byte_Text_IO.Put (C);
                     Put ("]");
                  else
                     Put ("[");
                     Put (Character'Val (C));
                     Put ("]");
                  end if;
               end if;
            when Opt_IAC =>
               if C = Telnet.Protocol.IAC then
                  Option_In.Append (C);
                  Put ("[");
                  Byte_Text_IO.Put (C);
                  Put ("]");
                  S := Opt;
               elsif C = Telnet.Protocol.SE then
                  Put ("[SE]");
                  Put ("[Length = ");
                  Put (Option_In.Length'Image);
                  Put ("]");
                  Option_In.Clear;
                  S := Data;
                  Got_Reply := True;
               else
                  S := Opt;
               end if;
            when others =>
               null;
         end case;
      end loop;
      end loop;
      Put_Line ("Worker done");
   end Worker;

end Telnet.Workers;
