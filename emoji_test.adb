with Ada.Wide_Text_IO; use Ada.Wide_Text_IO;
with Emoji; use Emoji;

procedure Emoji_Test is
   C : Wide_Character;
   F1 : Ada.Wide_Text_IO.File_Type;
begin

   Put_Line ("Test");

   Ada.Wide_Text_IO.Create (F1, Out_File, "emoji.txt", "WCEM=8");

   Put (F1, Emoji.White_Heavy_Check_Mark);
   Put (F1, Emoji.Variation_Selector_Emoji);

   Put (F1, Emoji.Cross_Mark);
   Put (F1, Emoji.Variation_Selector_Emoji);

   Ada.Wide_Text_IO.Close (F1);

end Emoji_Test;
