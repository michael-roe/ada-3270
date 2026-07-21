with Ada.Text_IO;
with Ada.Wide_Text_IO;
with Ada.Strings.UTF_Encoding;
with Ada.Strings.UTF_Encoding.Wide_Strings;
with Code_Page_310;
with Code_Page_500;
with Box_Drawing;
with IBM_3270_Orders;
with Byte_Text_IO;
with Input_Stream;
with Ada.Containers;
use type Ada.Containers.Count_Type;
with Ada.Characters.Latin_1;

package body Split_Views is

   function Normal_Text return IBM_3270_Orders.Intensity renames
      IBM_3270_Orders.Normal_Text;

   procedure To_Physical (
      V : Split_View;
      Bytes_Out : in out Byte_Vectors.Vector) is
      B : Byte_Vectors.Vector;
      Line_Number : Natural;
   begin

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Down_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Down_Left);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      Code_Page_500.Append (Bytes_Out, " Split Panel Test");
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 1);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Left);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 69, 3);
      Code_Page_500.Append (Bytes_Out, "More: ");
      Code_Page_500.Append (Bytes_Out, "+");
      Code_Page_500.Append (Bytes_Out, " ");
      if V.Page_Number = 0 then
         Code_Page_500.Append (Bytes_Out, " ");
      else
         Code_Page_500.Append (Bytes_Out, "-");
      end if;
      Code_Page_500.Append (Bytes_Out, " ");
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      for J in 4 .. 19 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
         Line_Number := J - 4 + 16 * V.Page_Number;
         if Line_Number <= V.History.Last_Index then
            Code_Page_500.Append (
               Bytes_Out,
               Lines.To_Wide_String (V.History (Line_Number)));
         end if;
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 78, J);
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      end loop;

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Left);

      for J in 21 .. 39 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
         IBM_3270_Orders.Start_Field (Bytes_Out, False, Normal_Text);
         if J = 21 then
            IBM_3270_Orders.Insert_Cursor (Bytes_Out);
         end if;
         Code_Page_500.Append (
            Bytes_Out,
            Lines.To_Wide_String (V.Edit (J - 21)));
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 78, J);
         IBM_3270_Orders.Start_Field (Bytes_Out, True, Normal_Text);
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      end loop;

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 40);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical_Left);

      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);
      Code_Page_500.Append (Bytes_Out, " PF1=Help");
      Code_Page_500.Append (Bytes_Out, " PF3=Exit");
      Code_Page_500.Append (Bytes_Out, " PF7=Prev");
      Code_Page_500.Append (Bytes_Out, " PF8=Next");
      Code_Page_500.Append (Bytes_Out, " PF9=Swap");
      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 79, 41);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Vertical);

      IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 42);
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Up_Right);
      for J in 1 .. 78 loop
         Code_Page_310.Append (Bytes_Out, Box_Drawing.Horizontal);
      end loop;
      Code_Page_310.Append (Bytes_Out, Box_Drawing.Up_Left);

   end To_Physical;

   procedure From_Physical (
      V : in out Split_View;
      Bytes_In : Byte_Vectors.Vector) is
   begin
      Input_Stream.Parse (V, Bytes_In);
   end From_Physical;

   procedure Update_Cursor (
      V : in out Split_View;
      X : Natural;
      Y : Natural) is
   begin

      null;

   end Update_Cursor;

   procedure Update_Field (
      V : in out Split_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String) is
   begin
      Ada.Text_IO.Put ("(");
      Ada.Text_IO.Put (Natural'Image (X));
      Ada.Text_IO.Put (", ");
      Ada.Text_IO.Put (Natural'Image (Y));
      Ada.Text_IO.Put (", ");
      Ada.Wide_Text_IO.Put (Lines.To_Wide_String (L));
      Ada.Text_IO.Put (")");
      Ada.Text_IO.New_Line;

      V.Edit (Y - 21) := L;

   end Update_Field;

   procedure Prev_Page (V : in out Split_View) is
   begin

      Ada.Text_IO.Put ("Prev_Page");
      Ada.Text_IO.New_Line;
      if V.Page_Number > 0 then
         V.Page_Number := V.Page_Number - 1;
      end if;

   end Prev_Page;

   procedure Next_Page (V : in out Split_View) is
   begin

      if V.Page_Number < Natural (V.History.Length / 16) then
         V.Page_Number := V.Page_Number + 1;
      end if;

   end Next_Page;

   type Paragraph_State is (At_Start, Nonblank_Line, Blank_Line);

   procedure To_JSON (
      V : Split_View;
      TX2 : access Buffer_Queues.Queue) is
      State : Paragraph_State;
      New_Line : String := "" & Character'Val (10);
   begin

      State := At_Start;

      TX2.Enqueue (Character'Pos ('"'));
      for J in V.Edit'Range loop
         if Lines.Length (V.Edit (J)) = 0 then
            if State /= At_Start then
               State := Blank_Line;
            end if;
         else
            if State = Blank_Line then
               TX2.Enqueue (Character'Pos ('/'));
               TX2.Enqueue (Character'Pos ('n'));
            elsif State = Nonblank_Line then
               TX2.Enqueue (Character'Pos (' '));
            end if;
            State := Nonblank_Line;
         end if;
         declare
            Encoded : Ada.Strings.UTF_Encoding.UTF_8_String :=
               Ada.Strings.UTF_Encoding.Wide_Strings.Encode (
                  Lines.To_Wide_String (V.Edit (J)));
         begin
            for J in Encoded'Range loop
               --
               --  Escaping quotes on the UTF-8 encoded version of the string
               --  is a bit inelegant, but works due to property of the
               --  UTF-8 encoding.
               --
               if Encoded (J) = '\' then
                  TX2.Enqueue (Character'Pos ('\'));
                  TX2.Enqueue (Character'Pos ('\'));
               elsif Encoded (J) = '"' then
                  TX2.Enqueue (Character'Pos ('\'));
                  TX2.Enqueue (Character'Pos ('q'));
               else
                  TX2.Enqueue (Character'Pos (Encoded (J)));
               end if;
            end loop;
         end;
      end loop;
      if State /= At_Start then
         null;
         TX2.Enqueue (Character'Pos ('\'));
         TX2.Enqueue (Character'Pos ('n'));
      end if;
      TX2.Enqueue (Character'Pos ('"'));
      TX2.Enqueue (13);
      TX2.Enqueue (10);

   end To_JSON;

   procedure Edit_To_History (V : in out Split_View) is
      Last_Line : Natural;
      L : Lines.Bounded_Wide_String;
   begin

      Last_Line := V.Edit'Last;

      while Last_Line > V.Edit'First and
         Lines.Length (V.Edit (Last_Line)) = 0
      loop
         Last_Line := Last_Line - 1;
      end loop;

      for J in V.Edit'First .. Last_Line loop
         Line_Vectors.Append (V.History, V.Edit (J));
      end loop;

      for J in V.Edit'Range loop
         Lines.Set_Bounded_Wide_String (V.Edit (J), "");
      end loop;

   end Edit_To_History;

   procedure Put_Character (
      V : in out Split_View;
      C : in Wide_Character) is
      L : Lines.Bounded_Wide_String;
      L2 : Lines.Bounded_Wide_String;
      Last_Space : Natural;
   begin

      if Lines.Length (V.History.Element (V.History.Last_Index)) > 75 then
         L := V.History.Element (V.History.Last_Index);
         Last_Space := Lines.Length (L);
         Ada.Text_IO.Put ("Last_Space = ");
         Ada.Text_IO.Put_Line (Natural'Image (Last_Space));
         while (Last_Space > 0) and
            (Lines.Element (L, Last_Space) /= ' ')
         loop
            Last_Space := Last_Space - 1;
         end loop;
         if (Lines.Element (L, Last_Space) /= ' ') then
            --
            --  There's nowhere to break the line
            --
            Lines.Set_Bounded_Wide_String (L, "");
            Line_Vectors.Append (V.History, L);
         elsif Last_Space = Lines.Length (L) then
            --
            --  The line ends in a space
            --  (ought to trim it)
            --
            Lines.Set_Bounded_Wide_String (L, "");
            Line_Vectors.Append (V.History, L);
         else
            Lines.Bounded_Slice (L, L2, Last_Space + 1, Lines.Length (L));
            Lines.Head (L, Last_Space - 1, ' ');
            Line_Vectors.Replace_Element (V.History, V.History.Last_Index, L);
            Line_Vectors.Append (V.History, L2);
         end if;
      end if;

      --
      --  This is inefficient. There must be a better way to do it.
      --

      L := V.History.Element (V.History.Last_Index);
      Lines.Append (L, "" & C);
      Line_Vectors.Replace_Element (V.History, V.History.Last_Index, L);

   end Put_Character;

   procedure New_Line (V : in out Split_View) is
      L : Lines.Bounded_Wide_String;
   begin

      Lines.Set_Bounded_Wide_String (L, "");
      Line_Vectors.Append (V.History, L);

   end New_Line;

end Split_Views;
