with Ada.Wide_Text_IO;
with Unicode.Names.Box_Drawing;
with Box_Drawing;

procedure Test_Box is

   F1 : Ada.Wide_Text_IO.File_Type;

   Horizontal : constant Wide_Character := Wide_Character'Val (
      Unicode.Names.Box_Drawing.Box_Drawings_Light_Horizontal);

   Vertical : constant Wide_Character := Wide_Character'Val (
      Unicode.Names.Box_Drawing.Box_Drawings_Light_Vertical);
      
begin

   Ada.Wide_Text_IO.Create (F1, Ada.Wide_Text_IO.Out_File,
      "boxes.txt", "WCEM=8");

   Ada.Wide_Text_IO.Put (F1, "Up Right: ");
   Ada.Wide_Text_IO.Put (F1, Box_Drawing.Up_Right);
   Ada.Wide_Text_IO.New_Line (F1);

   Ada.Wide_Text_IO.Put (F1, "Down Right: ");
   Ada.Wide_Text_IO.Put (F1, Box_Drawing.Down_Right);
   Ada.Wide_Text_IO.New_Line (F1);

   Ada.Wide_Text_IO.Put (F1, "Up Left: ");
   Ada.Wide_Text_IO.Put (F1, Box_Drawing.Up_Left);
   Ada.Wide_Text_IO.New_Line (F1);

   Ada.Wide_Text_IO.Put (F1, "Down Left: ");
   Ada.Wide_Text_IO.Put (F1, Box_Drawing.Down_Left);
   Ada.Wide_Text_IO.New_Line (F1);

   Ada.Wide_Text_IO.New_Line (F1);

   Ada.Wide_Text_IO.Put (F1, Box_Drawing.Down_Right);
   Ada.Wide_Text_IO.Put (F1, Horizontal);
   Ada.Wide_Text_IO.Put (F1, Horizontal);
   Ada.Wide_Text_IO.Put (F1, Horizontal);
   Ada.Wide_Text_IO.Put (F1, Box_Drawing.Down_Left);
   Ada.Wide_Text_IO.New_Line (F1);

   Ada.Wide_Text_IO.Put (F1, Vertical);
   Ada.Wide_Text_IO.Put (F1, " ");
   Ada.Wide_Text_IO.Put (F1, " ");
   Ada.Wide_Text_IO.Put (F1, " ");
   Ada.Wide_Text_IO.Put (F1, Vertical);
   Ada.Wide_Text_IO.New_Line (F1);

   Ada.Wide_Text_IO.Put (F1, Box_Drawing.Vertical_Right);
   Ada.Wide_Text_IO.Put (F1, Horizontal);
   Ada.Wide_Text_IO.Put (F1, Horizontal);
   Ada.Wide_Text_IO.Put (F1, Horizontal);
   Ada.Wide_Text_IO.Put (F1, Box_Drawing.Vertical_Left);
   Ada.Wide_Text_IO.New_Line (F1);

   Ada.Wide_Text_IO.Put (F1, Box_Drawing.Up_Right);
   Ada.Wide_Text_IO.Put (F1, Horizontal);
   Ada.Wide_Text_IO.Put (F1, Horizontal);
   Ada.Wide_Text_IO.Put (F1, Horizontal);
   Ada.Wide_Text_IO.Put (F1, Box_Drawing.Up_Left);
   Ada.Wide_Text_IO.New_Line (F1);

end Test_Box;
