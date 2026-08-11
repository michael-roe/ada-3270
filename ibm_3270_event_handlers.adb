with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;
with GNATCOLL.JSON;
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
with Progress_Views;
with Outputable_Views;
with IBM_3270;
with Lines;
with Line_Vectors;
with Geometric_Shapes;
with Block_Elements;
with Math_Operators;
with View_Text_IO;

package body IBM_3270_Event_Handlers is

   Screen_Message : Buffer.Byte_Array := (
      IBM_3270.IBM_Write_Erase_Alternate,
      IBM_3270.WCC_Go_Ahead);

   Login_Screen : aliased Login_Views.Login_View;

   Main_Menu : aliased Menu_Views.Menu_View;

   Summon_Menu : aliased Menu_Views.Menu_View;

   Entity_Menu : aliased Menu_Views.Menu_View;

   Identity_Input : aliased Text_Views.Text_View;

   Intent_Input : aliased Split_Views.Split_View;

   Checkboxes : aliased Checkbox_Views.Checkbox_View;

   Progress_Screen : aliased Progress_Views.Progress_View;

   procedure To_Physical (
      V         : in out IBM_3270_Handler;
      Bytes_Out : in out Byte_Vectors.Vector;
      P         : Code_Pages.Code_Page_Access;
      Go_Ahead  : in out Boolean) is
   begin

      for J in Screen_Message'Range loop
         Bytes_Out.Append (Screen_Message (J));
      end loop;

      V.Current.To_Physical (Bytes_Out, P);

      Go_Ahead := True;

   exception

      when My_Error : others =>
         Ada.Text_IO.Put_Line ("To_Physical: Exception raised");

         Bytes_Out.Clear;

         for J in Screen_Message'Range loop
            Bytes_Out.Append (Screen_Message (J));
         end loop;

         V.Current := Login_Screen'Access;

         V.Current.To_Physical (Bytes_Out, P);

         Go_Ahead := True;

   end To_Physical;

   procedure From_Physical (
      V        : in out IBM_3270_Handler;
      Bytes_In : Byte_Vectors.Vector;
      P        : Code_Pages.Code_Page_Access) is
      AID : Buffer.Byte;
      L : Lines.Bounded_Wide_String;
      After_Backslash : Boolean;
      Backend_Byte : Buffer.Byte;
      Hex_Digits : String := "16#0000#";
      From_Backend : Ada.Strings.Unbounded.Unbounded_String;
      Backend_Object : GNATCOLL.JSON.JSON_Value;
      Backend_UTF8 : GNATCOLL.JSON.UTF8_Unbounded_String;
      Output_Interface : Outputable_Views.Outputable_Access;
   begin

      begin

         V.Current.From_Physical (Bytes_In, P);

      exception

         when My_Error : others =>
            Ada.Text_IO.Put_Line ("From_Physical: Exception raised");
            V.Current := Login_Screen'Access;
            return;

      end;

      AID := V.Current.Get_AID;

      if AID = IBM_3270.AID_PF7 then
         V.Pageable.Prev_Page;
      elsif AID = IBM_3270.AID_PF8 then
         V.Pageable.Next_Page;
      elsif AID = IBM_3270.AID_Enter then
         V.JSONable.To_JSON (V.TX2);
         V.TX2.Enqueue (13);
         V.TX2.Enqueue (10);
         Intent_Input.New_Line;
         Intent_Input.Edit_To_History;
         Intent_Input.New_Line;
         Intent_Input.New_Line;
         Backend_Byte := 0;
         Ada.Strings.Unbounded.Set_Unbounded_String (From_Backend, "");
         while Backend_Byte /= 10 loop
            V.RX2.Dequeue (Backend_Byte);
            if Backend_Byte /= 13 then
               Ada.Strings.Unbounded.Append (From_Backend,
                  Character'Val (Backend_Byte));
            end if;
         end loop;
         --  Ada.Text_IO.Put_Line ("Got string from backend");
         Backend_Object := GNATCOLL.JSON.Read (From_Backend);
         --  Ada.Text_IO.Put_Line ("Read done");
         Backend_UTF8 := GNATCOLL.JSON.Get (Backend_Object);
         --  Ada.Text_IO.Put_Line ("Get done");
         View_Text_IO.Put (V.Outputable, Backend_UTF8);
         --  Ada.Text_IO.Put_Line ("Put done");

         case V.State  is
            when Login_Panel =>
               V.Current := Main_Menu'Access;
               V.Pageable := Main_Menu'Access;
               V.JSONable := Main_Menu'Access;
               V.State := Main_Panel;
            when Main_Panel =>
               if Main_Menu.Get_Option /= 0 then
                  V.Current := Entity_Menu'Access;
                  V.Pageable := Entity_Menu'Access;
                  V.JSONable := Entity_Menu'Access;
                  V.State := Entity_Panel;
               end if;
            when Entity_Panel =>
                  V.Current  := Identity_Input'Access;
                  V.Pageable := Identity_Input'Access;
                  --  V.JSONable := Identity_Menu'Access;
                  V.State    := Identity_Panel;
            when Identity_Panel =>
                  V.Current  := Summon_Menu'Access;
                  V.Pageable := Summon_Menu'Access;
                  V.JSONable := Summon_Menu'Access;
                  V.State    := Summon_Panel;
            when Summon_Panel =>
               if Summon_Menu.Get_Option /= 0 then
                  V.Current  := Intent_Input'Access;
                  V.Pageable := Intent_Input'Access;
                  V.JSONable := Intent_Input'Access;
                  V.State    := Intent_Panel;
               end if;
            when Intent_Panel =>
               null;
            when others =>
               null;
         end case;
      elsif AID = IBM_3270.AID_CrSel then
         Ada.Text_IO.Put_Line ("CrSel");
      elsif AID = IBM_3270.AID_SysReq then
         Ada.Text_IO.Put_Line ("SysReq");
      end if;

   end From_Physical;

   procedure Break (V : in out IBM_3270_Handler) is
   begin

      Ada.Text_IO.Put_Line ("Break called");

   end Break;

   procedure Initialize (V : in out IBM_3270_Handler) is
      L : Lines.Bounded_Wide_String;
   begin

      V.Current := Login_Screen'Access;
      V.Pageable := Main_Menu'Access;
      V.JSONable := Main_Menu'Access;
      V.Outputable := Intent_Input'Access;
      V.State := Login_Panel;

      Lines.Set_Bounded_Wide_String (L, "Login");
      Login_Screen.Set_Title (L);

      Lines.Set_Bounded_Wide_String (L, "Cantrip");
      Main_Menu.Set_Title (L);
      Lines.Set_Bounded_Wide_String (L,
         "Move the cursor to an option and press Enter");
      Main_Menu.Set_Intro (L);
      Lines.Set_Bounded_Wide_String (L, "Summon Entity");
      Main_Menu.Set_Label (1, L);
      Lines.Set_Bounded_Wide_String (L, "Contact Entity");
      Main_Menu.Set_Label (2, L);
      Lines.Set_Bounded_Wide_String (L, "New Cantrip");
      Main_Menu.Set_Label (3, L);
      Lines.Set_Bounded_Wide_String (L, "Edit Cantrip");
      Main_Menu.Set_Label (4, L);

      Lines.Set_Bounded_Wide_String (L, "Cantrip");
      Entity_Menu.Set_Title (L);
      Lines.Set_Bounded_Wide_String (L,
        "Select which property of the Cantrip to modify");
      Entity_Menu.Set_Intro (L);
      Lines.Set_Bounded_Wide_String (L, "Identity (Prompt)");
      Entity_Menu.Set_Label (1, L);
      Lines.Set_Bounded_Wide_String (L, "Identity (Parameters)");
      Entity_Menu.Set_Label (2, L);
      Lines.Set_Bounded_Wide_String (L, "Gates");
      Entity_Menu.Set_Label (3, L);
      Lines.Set_Bounded_Wide_String (L, "Wards");
      Entity_Menu.Set_Label (4, L);
      Lines.Set_Bounded_Wide_String (L, "Circle");
      Entity_Menu.Set_Label (5, L);

      Lines.Set_Bounded_Wide_String (L, "Cantrip");
      Identity_Input.Set_Title (L);
      Lines.Set_Bounded_Wide_String (L, "Identity");
      Identity_Input.Set_Subtitle (L);

      Lines.Set_Bounded_Wide_String (L, "Cantrip");
      Summon_Menu.Set_Title (L);
      Lines.Set_Bounded_Wide_String (L,
         "Select a Cantrip to Summon an Entity");
      Summon_Menu.Set_Intro (L);
      --  Lines.Set_Bounded_Wide_String (L, "Cantrip");
      --  Summon_Menu.Set_Subtitle (L);
      Lines.Set_Bounded_Wide_String (L, "Default Identity");
      Summon_Menu.Set_Label (1, L);
      Lines.Set_Bounded_Wide_String (L, "Custom Cantrip");
      Summon_Menu.Set_Label (2, L);
      Lines.Set_Bounded_Wide_String (L, "Roleplay");
      Summon_Menu.Set_Label (3, L);
      Lines.Set_Bounded_Wide_String (L, "Back Translation");
      Summon_Menu.Set_Label (4, L);
      Lines.Set_Bounded_Wide_String (L, "Sentiment Analysis");
      Summon_Menu.Set_Label (5, L);
      Lines.Set_Bounded_Wide_String (L, "Descarte's Demon");
      Summon_Menu.Set_Label (6, L);
      --  Qwen3.6-27B
      --  GLM-5.2
      --  Kimi-K2.7-Code

      Lines.Set_Bounded_Wide_String (L, "Cantrip");
      Intent_Input.Set_Title (L);
      Lines.Set_Bounded_Wide_String (L, "Cast ===>");
      Intent_Input.Set_Subtitle (L);

      --  for J in 1 .. 50 loop
      --     Lines.Set_Bounded_Wide_String (L,
      --        "Line" & Natural'Wide_Image (J));
      --     Line_Vectors.Append (Intent_Input.History, L);
      --  end loop;

      Lines.Set_Bounded_Wide_String (L, "Checkbox Test");
      Checkboxes.Set_Title (L);
      for J in 1 .. 4 loop
         Lines.Set_Bounded_Wide_String (L, "Box " & Natural'Wide_Image (J));
         Checkboxes.Set_Label (J, L);
      end loop;
      Checkboxes.Set_Checkbox (1, True);
      Checkboxes.Set_Checkbox (2, True);
      Checkboxes.Set_Checkbox (3, False);
      Checkboxes.Set_Checkbox (4, False);

      Lines.Set_Bounded_Wide_String (L, "Progress Bar");
      Progress_Screen.Set_Title (L);

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
