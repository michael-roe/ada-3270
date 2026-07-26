with Ada.Text_IO;
with Buffer;
use type Buffer.Byte;
with Views;
with Pageable_Views;
with Text_Views;
with JSON_Views;
with Split_Views;
with Checkbox_Views;
with Numbered_Menu_Views;
with Menu_Views;
with Login_Views;
with IBM_3270;
with Lines;
with Line_Vectors;

package body IBM_3270_Event_Handlers is

   Screen_Message : Buffer.Byte_Array := (
      IBM_3270.IBM_Write_Erase_Alternate,
      IBM_3270.WCC_Go_Ahead);

   Main_Menu : aliased Numbered_Menu_Views.Numbered_Menu_View;

   Model_Menu : aliased Numbered_Menu_Views.Numbered_Menu_View;

   Identity_Input : aliased Text_Views.Text_View;

   Split : aliased Split_Views.Split_View;

   Checkboxes : aliased Checkbox_Views.Checkbox_View;

   procedure To_Physical (
      V         : in out IBM_3270_Handler;
      Bytes_Out : in out Byte_Vectors.Vector;
      Go_Ahead  : in out Boolean) is
   begin

      for J in Screen_Message'Range loop
         Bytes_Out.Append (Screen_Message (J));
      end loop;

      V.Current.To_Physical (Bytes_Out);

      Go_Ahead := True;

   end To_Physical;

   procedure From_Physical (
      V : in out IBM_3270_Handler;
      Bytes_In : Byte_Vectors.Vector) is
      AID : Buffer.Byte;
      L : Lines.Bounded_Wide_String;
      After_Backslash : Boolean;
      Backend_Byte : Buffer.Byte;
      Hex_Digits : String := "16#0000#";
   begin

      V.Current.From_Physical (Bytes_In);

      AID := V.Current.Get_AID;

      if AID = IBM_3270.AID_PF7 then
         V.Pageable.Prev_Page;
      elsif AID = IBM_3270.AID_PF8 then
         V.Pageable.Next_Page;
      elsif AID = IBM_3270.AID_Enter then
         V.JSONable.To_JSON (V.TX2);
         Split.Edit_To_History;
         Lines.Set_Bounded_Wide_String (L, "");
         Line_Vectors.Append (Split.History, L);
         After_Backslash := False;
         Backend_Byte := 0;
         while Backend_Byte /= 10 loop
            V.RX2.Dequeue (Backend_Byte);
            if After_Backslash then
               if Backend_Byte = Character'Pos ('\') then
                  Split.Put_Character ('\');
               elsif Backend_Byte = Character'Pos ('"') then
                  Split.Put_Character ('"');
               elsif Backend_Byte = Character'Pos ('n') then
                  Split.New_Line;
               elsif Backend_Byte = Character'Pos ('u') then
                  --  Ada.Text_IO.Put_Line ("Hex string");
                  V.RX2.Dequeue (Backend_Byte);
                  Hex_Digits (4) :=
                     Character'Val (Backend_Byte);
                  V.RX2.Dequeue (Backend_Byte);
                  Hex_Digits (5) :=
                     Character'Val (Backend_Byte);
                  V.RX2.Dequeue (Backend_Byte);
                  Hex_Digits (6) :=
                     Character'Val (Backend_Byte);
                  V.RX2.Dequeue (Backend_Byte);
                  Hex_Digits (7) :=
                     Character'Val (Backend_Byte);
                  --  Ada.Text_IO.Put_Line (Hex_Digits);
                  Split.Put_Character (
                     Wide_Character'Val (
                        Integer'Value (Hex_Digits)));
               end if;
               After_Backslash := False;
            else
               if Backend_Byte = 13 then
                  null;
               elsif Backend_Byte = Character'Pos ('\') then
                  After_Backslash := True;
               elsif Backend_Byte = Character'Pos ('"') then
                  --
                  --  JSON strings can't contain a quote character,
                  --  but will be terminated by one.
                  --
                  null;
               elsif Backend_Byte < 128 then
                  Split.Put_Character (
                     Wide_Character'Val (Backend_Byte));
               else
                  --
                  --  Multi-byte UTF-8 character
                  --
                  Split.Put_Character ('?');
               end if;
            end if;
         end loop;

         case V.State  is
            when Main_Menu_Panel =>
               if Main_Menu.Option /= 0 then
                  V.Current  := Model_Menu'Access;
                  V.Pageable := Model_Menu'Access;
                  V.JSONable := Model_Menu'Access;
                  V.State    := Model_Menu_Panel;
               end if;
            when Model_Menu_Panel =>
               if Model_Menu.Option /= 0 then
                  V.Current  := Identity_Input'Access;
                  V.Pageable := Identity_Input'Access;
                  --  V.JSONable := Identity_Input'Access;
                  V.State    := Identity_Panel;
               end if;
            when Identity_Panel =>
               V.Current  := Split'Access;
               V.Pageable := Split'Access;
               V.JSONable := Split'Access;
               V.State    := Split_Panel;
            when others =>
               null;
         end case;

      end if;

   end From_Physical;

   procedure Break (V : in out IBM_3270_Handler) is
   begin

      Ada.Text_IO.Put_Line ("Break called");

   end Break;

   procedure Initialize (V : in out IBM_3270_Handler) is
      L : Lines.Bounded_Wide_String;
   begin

      V.Current := Main_Menu'Access;
      V.Pageable := Main_Menu'Access;
      V.JSONable := Main_Menu'Access;
      V.State := Main_Menu_Panel;

      Lines.Set_Bounded_Wide_String (L, "Summon");
      Numbered_Menu_Views.Set_Label (Main_Menu, 1, L);
      Lines.Set_Bounded_Wide_String (L, "Model");
      Numbered_Menu_Views.Set_Label (Main_Menu, 2, L);
      Lines.Set_Bounded_Wide_String (L, "Identity (Prompt)");
      Numbered_Menu_Views.Set_Label (Main_Menu, 3, L);
      Lines.Set_Bounded_Wide_String (L, "Identity (Parameters)");
      Numbered_Menu_Views.Set_Label (Main_Menu, 4, L);
      Lines.Set_Bounded_Wide_String (L, "Gates");
      Numbered_Menu_Views.Set_Label (Main_Menu, 5, L);
      Lines.Set_Bounded_Wide_String (L, "Wards");
      Numbered_Menu_Views.Set_Label (Main_Menu, 6, L);

      Lines.Set_Bounded_Wide_String (L, "Qwen3.6-27B");
      Numbered_Menu_Views.Set_Label (Model_Menu, 1, L);
      Lines.Set_Bounded_Wide_String (L, "GLM-5.2");
      Numbered_Menu_Views.Set_Label (Model_Menu, 2, L);
      Lines.Set_Bounded_Wide_String (L, "Kimi-K2.7-Code");
      Numbered_Menu_Views.Set_Label (Model_Menu, 3, L);

      --  for J in 1 .. 50 loop
      --     Lines.Set_Bounded_Wide_String (L,
      --        "Line" & Natural'Wide_Image (J));
      --     Line_Vectors.Append (Split.History, L);
      --  end loop;

      Checkboxes.Checkboxes (1) := True;
      Checkboxes.Checkboxes (2) := True;
      Checkboxes.Checkboxes (3) := False;
      Checkboxes.Checkboxes (4) := False;

   end Initialize;

   procedure Set_RX_TX (
      V  : in out IBM_3270_Handler;
      RX : access Buffer_Queues.Queue;
      TX : access Buffer_Queues.Queue) is
   begin

      V.RX2 := RX;
      V.TX2 := TX;

   end Set_RX_TX;

end IBM_3270_Event_Handlers;
