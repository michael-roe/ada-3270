with Ada.Text_IO; use Ada.Text_IO;
with Ada.Wide_Text_IO;
with Ada.Text_IO.Text_Streams;
with Ada.Wide_Text_IO.Text_Streams;
with Ada.Containers;
with Ada.Streams;
use type Ada.Containers.Count_Type;
with Buffer; use type Buffer.Byte;
with Byte_Vectors;
with Byte_Text_IO;
with Telnet.Protocol;
with Telnet.Options;
with Telnet.Terminal;
with Telnet.Environ;
with Telnet.Negotiation; use Telnet.Negotiation;
with IBM_3270;
with Box_Drawing;
with Block_Elements;
with Math_Operators;
with Code_Page_310;
with Code_Page_500;
with IBM_3270_Orders;
with Text_Views;
with Split_Views;
with Checkbox_Views;
with Menu_Views;
with Login_Views;
with Lines;
with Line_Vectors;

package body Telnet.Workers is

   function Normal_Text return IBM_3270_Orders.Intensity renames
     IBM_3270_Orders.Normal_Text;

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
      IBM_3270.IBM_Write_Erase_Alternate,
      IBM_3270.WCC_Go_Ahead);

   procedure Rx_Record (Bytes_In : Byte_Vectors.Vector) is
      X : Natural;
      Y : Natural;
   begin
      Put ("[Length = ");
      Put (Bytes_In.Length'Image);
      Put ("]");
      case Bytes_In.Element (Bytes_In.First_Index) is
         when IBM_3270.AID_Enter =>
            Put ("[Enter]");
         when IBM_3270.AID_PA1 =>
            Put ("[PA1]");
         when IBM_3270.AID_PA2 =>
            Put ("[PA2]");
         when IBM_3270.AID_PA3 =>
            Put ("[PA3]");
         when IBM_3270.AID_PF7 =>
            Put ("[PF7]");
         when IBM_3270.AID_PF8 =>
            Put ("[PF8]");
         when IBM_3270.AID_CrSel =>
            Put ("[CrSel]");
         when others =>
            Put ("[AID ");
            Byte_Text_IO.Put (Bytes_In.Element (Bytes_In.First_Index));
            Put ("]");
      end case;

      if Bytes_In.Length > 2 then
         IBM_3270_Orders.To_Buffer_Address (
            Bytes_In.Element (Bytes_In.First_Index + 1),
            Bytes_In.Element (Bytes_In.First_Index + 2),
            X,
            Y);

         Put ("Cursor = (");
         Ada.Text_IO.Put (Natural'Image (X));
         Ada.Text_IO.Put (Natural'Image (Y));
         Put (")");
      end if;

   end Rx_Record;

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
      Document : Split_Views.Split_View;
      L : Lines.Bounded_Wide_String;
      Backend_Byte : Buffer.Byte;
      After_Backslash : Boolean;
   begin

      for J in 1 .. 50 loop
         Lines.Set_Bounded_Wide_String (L, "Line" & Natural'Wide_Image (J));
         Line_Vectors.Append (Document.History, L);
      end loop;

      --  Document.Checkboxes (1) := True;
      --  Document.Checkboxes (2) := True;
      --  Document.Checkboxes (3) := False;
      --  Document.Checkboxes (4) := False;

      for J in 1 .. 30 loop -- only 8 options to send

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
                  Bytes_Out.Clear;
                  for J in Screen_Message'Range loop
                     Bytes_Out.Append (Screen_Message (J));
                  end loop;

                  Document.To_Physical (Bytes_Out);

                  if Bytes_Out.Length > 0 then
                     for J in 0 .. Integer (Bytes_Out.Length) - 1 loop
                        TX.Enqueue (Bytes_Out.Element (J));
                     end loop;
                  end if;
                  TX.Enqueue (Telnet.Protocol.IAC);
                  TX.Enqueue (Telnet.Protocol.EOR);
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
                        Put ("[BREAK]");
                        S := Data;
                        Got_Reply := True;
                     when Telnet.Protocol.EOR =>
                        --  Put ("[EOR]");
                        Document.From_Physical (Bytes_In);
                        if Bytes_In.Element (Bytes_In.First_Index) =
                           IBM_3270.AID_PF7
                        then
                           Document.Prev_Page;
                        elsif Bytes_In.Element (Bytes_In.First_Index) =
                           IBM_3270.AID_PF8
                        then
                           Document.Next_Page;
                        end if;
                        Rx_Record (Bytes_In);
                        if Bytes_In.Element (Bytes_In.First_Index) =
                           IBM_3270.AID_Enter
                        then
                           Split_Views.To_JSON (Document,
                              TX2);
                           Document.Edit_To_History;
                           Lines.Set_Bounded_Wide_String (L, "");
                           Line_Vectors.Append (Document.History, L);
                           After_Backslash := False;
                           Backend_Byte := 0;
                           while Backend_Byte /= 10 loop
                              RX2.Dequeue (Backend_Byte);
                              if After_Backslash then
                                 if Backend_Byte = Character'Pos ('\') then
                                    Document.Put_Character ('\');
                                  elsif Backend_Byte = Character'Pos ('q') then
                                     Document.Put_Character ('"');
                                  end if;
                                  After_Backslash := False;
                              else
                                 if Backend_Byte = 13 then
                                    null;
                                 elsif Backend_Byte = Character'Pos ('\') then
                                    After_Backslash := True;
                                 else
                                    Document.Put_Character (
                                       Wide_Character'Val (Backend_Byte));
                                 end if;
                              end if;
                           end loop;
                        end if;
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
                     --  Option_In.Clear;
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
