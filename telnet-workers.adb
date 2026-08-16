with Ada.Text_IO; use Ada.Text_IO;
with Ada.Wide_Text_IO;
with Ada.Text_IO.Text_Streams;
with Ada.Wide_Text_IO.Text_Streams;
with Ada.Containers;
with Ada.Streams;
with Ada.Exceptions;
use type Ada.Containers.Count_Type;
with Buffer; use type Buffer.Byte;
with Buffer_Queues; use Buffer_Queues;
with Byte_Vectors;
with Byte_Text_IO;
with Telnet.Protocol;
with Telnet.Options;
with Telnet.Terminal;
with Telnet_Strings;
with Telnet.Environ;
with Telnet.Negotiation; use Telnet.Negotiation;
with Telnet_Strings;
use type Telnet_Strings.Bounded_String;
with IBM_3270;
with Code_Pages;
with Code_Page_500;
with Code_Page_870;
with Code_Page_875;
with Code_Page_880;
with Code_Page_924;
with Code_Page_1025;

package body Telnet.Workers is

   type State is (Data, Data_IAC, Will, Wont, Do_It, Dont, Opt, Opt_IAC);

   procedure Environment_Undefined (
      N : Telnet_Strings.Bounded_String;
      User_Variable : Boolean);

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

   P500 : aliased Code_Page_500.Page_500;

   P870 : aliased Code_Page_870.Page_870;

   P875 : aliased Code_Page_875.Page_875;

   P880 : aliased Code_Page_880.Page_880;

   P924 : aliased Code_Page_924.Page_924;

   P1025 : aliased Code_Page_1025.Page_1025;

   procedure Environment_Undefined (
      N : Telnet_Strings.Bounded_String;
      User_Variable : Boolean) is
   begin

      Ada.Text_IO.Put_Line ("Telnet environment variable undefined");

   end Environment_Undefined;

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
      Go_Ahead : Boolean := False;
      RX_Empty : Boolean;
      Session_Code_Page : Code_Pages.Code_Page_Access;

      procedure Handle_Environment (
           N : Telnet_Strings.Bounded_String;
           V : Telnet_Strings.Bounded_String;
           User_Variable : Boolean);

      procedure Handle_Environment (
           N : Telnet_Strings.Bounded_String;
           V : Telnet_Strings.Bounded_String;
           User_Variable : Boolean) is
      begin

         Ada.Text_IO.Put (Telnet_Strings.To_String (N));
         Ada.Text_IO.Put (" = ");
         Ada.Text_IO.Put (Telnet_Strings.To_String (V));
         Ada.Text_IO.New_Line;

         if N = "CODEPAGE" then
            if V = "500" then
               Session_Code_Page := P500'Access;
            elsif V = "870" then
               Session_Code_Page := P870'Access;
            elsif V = "875" then
               Session_Code_Page := P875'Access;
            elsif V = "880" then
               Session_Code_Page := P880'Access;
            elsif V = "924" then
               Session_Code_Page := P924'Access;
            elsif V = "1025" then
               Session_Code_Page := P1025'Access;
            end if;
         end if;

      end Handle_Environment;

      procedure Parse_Environ is new
         Telnet.Environ.Parse (
            Callback => Handle_Environment,
            Callback_Undef => Environment_Undefined);

   begin

      accept Connect;

      begin

         Handler.Initialize;

      exception
         when My_Error : others =>
            Ada.Text_IO.Put ("Exception raised during initalization: ");
            Ada.Text_IO.Put (
               Ada.Exceptions.Exception_Name (My_Error));
            Ada.Text_IO.New_Line;
            Ada.Text_IO.Put (
               Ada.Exceptions.Exception_Message (My_Error));
            Ada.Text_IO.New_Line;

      end;

      Session_Code_Page := P500'Access;

      for J in 1 .. 10000 loop -- only 8 options to send

         Next_Option (Direction, Option);

         case Direction is
            when Offer =>
               --  Ada.Text_IO.Put_Line ("Offer");
               Telnet.Negotiation.Offer_Enable (Option, WW);
               case WW is
                  when Send_Nothing =>
                     null;
                  when Send_Wont =>
                     null;
                  when Send_Will =>
                     --  Ada.Text_IO.Put_Line ("Sending WILL");
                     TX.Enqueue (Telnet.Protocol.IAC);
                     TX.Enqueue (Telnet.Protocol.WILL);
                     TX.Enqueue (Option);
               end case;
            when Request =>
               --  Ada.Text_IO.Put_Line ("Request");
               Telnet.Negotiation.Request_Enable (Option, DD);
               case DD is
                  when Send_Nothing =>
                     null;
                  when Send_Dont =>
                     null;
                  when Send_Do_It =>
                     --  Ada.Text_IO.Put_Line ("Sending DO");
                     TX.Enqueue (Telnet.Protocol.IAC);
                     TX.Enqueue (Telnet.Protocol.DOIT);
                     TX.Enqueue (Option);
               end case;
            when Done =>
               --  Ada.Text_IO.Put_Line ("Negotiation done");
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
                  Go_Ahead := False;

                  while not Go_Ahead loop

                     declare
                        Q : access Buffer_Queues.Queue := RX;
                     begin
                        RX_Empty := Q.Is_Empty;
                     end;

                     if not RX_Empty then
                        RX.Dequeue (C);
                        if C = IBM_3270.AID_PA1 then
                           --
                           --  I'm not sure if it's valid to receive PA1 here
                           --
                           Ada.Text_IO.Put ("[PA1]");
                        elsif C /= Telnet.Protocol.IAC then
                           --
                           --  I think it's a protocol error to receive data
                           --  when the terminal does not have go ahead.
                           --
                           Ada.Text_IO.Put ("Received data unexpectedly ");
                           Byte_Text_IO.Put (C, Base => 16);
                           Ada.Text_IO.New_Line;
                        else
                           RX.Dequeue (C);
                           if C = Telnet.Protocol.BRK then
                              Ada.Text_IO.Put ("[BREAK]");
                              Handler.Break;
                           elsif C = Telnet.Protocol.IP then
                              Ada.Text_IO.Put ("[IP]");
                              Handler.Break;
                           elsif C = Telnet.Protocol.AO then
                              Ada.Text_IO.Put ("[AO]");
                              Handler.Break;
                           else
                              --
                              --  It's probably valid protocol for the
                              --  terminal to send WILL/WONT etc. here, but
                              --  this implementation doesn't support it.
                              --
                              Ada.Text_IO.Put_Line (
                                 "Was expecting Telnet break");
                           end if;
                        end if;
                     end if;

                     Bytes_Out.Clear;

                     begin

                        Handler.To_Physical (Bytes_Out,
                           Session_Code_Page,
                           Go_Ahead);

                     exception

                        when My_Error : others =>
                           Ada.Text_IO.Put ("Exception raised: ");
                           Ada.Text_IO.Put (
                              Ada.Exceptions.Exception_Name (My_Error));

                     end;

                     if Bytes_Out.Length > 0 then
                        for J in 0 .. Integer (Bytes_Out.Length) - 1 loop
                           TX.Enqueue (Bytes_Out.Element (J));
                        end loop;
                     end if;
                     TX.Enqueue (Telnet.Protocol.IAC);
                     TX.Enqueue (Telnet.Protocol.EOR);

                  end loop;
               end if;
         end case;

         Got_Reply := False;
         while not Got_Reply loop
            RX.Dequeue (C);
            --  Put ("[");
            --  Put (Buffer.Byte'Image (C));
            --  Put ("]");
            case S is
               when Data =>
                  if C = Telnet.Protocol.IAC then
                     --  Put ("[IAC]");
                     S := Data_IAC;
                  else
                     Bytes_In.Append (C);
                     --  Put ("[");
                     --  Ada.Text_IO.Put (Character'Val (C));
                     --  Put ("]");
                  end if;
               when Data_IAC =>
                  case C is
                     when Telnet.Protocol.WILL =>
                        --  Put ("[WILL]");
                        S := Will;
                     when Telnet.Protocol.WONT =>
                        --  Put ("[WONT]");
                        S := Wont;
                     when Telnet.Protocol.DOIT =>
                        --  Put ("[DO]");
                        S := Do_It;
                     when Telnet.Protocol.DONT =>
                        --  Put ("[DONT]");
                        S := Dont;
                     when Telnet.Protocol.SB =>
                        --  Put ("[SB]");
                        S := Opt;
                     when Telnet.Protocol.BRK =>
                        --  Put ("[BREAK]");
                        Handler.Break;
                        S := Data;
                        Got_Reply := True;
                     when Telnet.Protocol.IP =>
                        Put ("[IP]");
                        Handler.Break;
                        S := Data;
                        Got_Reply := True;
                     when Telnet.Protocol.AO =>
                        Put ("[AO]");
                        Handler.Break;
                        S := Data;
                        Got_Reply := True;
                     when Telnet.Protocol.EOR =>
                        --  Put ("[EOR]");
                        Handler.From_Physical (Bytes_In, Session_Code_Page);
                        Bytes_In.Clear;
                        S := Data;
                        Got_Reply := True;
                     when Telnet.Protocol.IAC =>
                        Bytes_In.Append (C);
                        --  Put ("[IAC]");
                        S := Data;
                     when others =>
                        S := Data;
                  end case;
               when Will =>
                  --  Put ("[");
                  --  Byte_Text_IO.Put (C);
                  --  Put ("]");
                  Telnet.Negotiation.Will (C, DD);
                  --  if Telnet.Negotiation.Is_Peer_Enabled (C) then
                  --     Put_Line ("[Enabled]");
                  --  end if;
                  S := Data;
                  Got_Reply := True;
               when Do_It =>
                  --  Put ("[");
                  --  Byte_Text_IO.Put (C);
                  --  Put ("]");
                  Telnet.Negotiation.Do_It (C, WW);
                  --  if Telnet.Negotiation.Is_Enabled (C) then
                  --     Put ("[Enabled]");
                  --  end if;
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
                     --   if C < 32 then
                     --      Put ("[");
                     --      Byte_Text_IO.Put (C);
                     --      Put ("]");
                     --   else
                     --      Put ("[");
                     --      Put (Character'Val (C));
                     --      Put ("]");
                     --  end if;
                  end if;
               when Opt_IAC =>
                  if C = Telnet.Protocol.IAC then
                     Option_In.Append (C);
                     --  Put ("[");
                     --  Byte_Text_IO.Put (C);
                     --  Put ("]");
                     S := Opt;
                  elsif C = Telnet.Protocol.SE then
                     --  Put ("[SE]");
                     --  Put ("[Length = ");
                     --  Put (Option_In.Length'Image);
                     --  Put ("]");
                     if Option_In.Length >= 2 then
                        if Option_In.Element (Option_In.First_Index) =
                           Telnet.Options.New_Environ
                        then
                           Parse_Environ (Option_In);
                        end if;
                     end if;
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
