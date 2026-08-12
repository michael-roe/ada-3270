with Ada.Characters.Conversions;
with Ada.Strings.UTF_Encoding;
with Ada.Strings.UTF_Encoding.Strings;
with Ada.Strings.UTF_Encoding.Wide_Strings;
with Ada.Strings.UTF_Encoding.Wide_Wide_Strings;
with Ada.Text_IO;
with Ada.Wide_Text_IO;
with Ada.Integer_Text_IO;
with Buffer;
use type Buffer.Byte;
with Punctuation;

package body View_Text_IO is

   procedure Put (
      V : Outputable_Views.Outputable_Access;
      S : Ada.Strings.Unbounded.Unbounded_String) is
      B : Buffer.Byte;
      Two_Bytes : Ada.Strings.UTF_Encoding.UTF_8_String := "  ";
      Three_Bytes : Ada.Strings.UTF_Encoding.UTF_8_String := "   ";
      Four_Bytes : Ada.Strings.UTF_Encoding.UTF_8_String := "    ";
      W : Wide_Character;
      WW : Wide_Wide_Character;
      C : Character;
      Index : Natural;
      To_Do : Natural;
   begin

      Index := 1;
      To_Do := Ada.Strings.Unbounded.Length (S);

      while To_Do > 0 loop
         B := Character'Pos (Ada.Strings.Unbounded.Element (S, Index));
         if B = 10 then
            V.New_Line;
            Index := Index + 1;
            To_Do := To_Do - 1;
         elsif B = 13 then
            Index := Index + 1;
            To_Do := To_Do - 1;
         elsif B < 128 then
            --  Ada.Text_IO.Put ("View_Text_IO: ");
            --  Ada.Text_IO.Put ("" &
            --     Ada.Strings.Unbounded.Element (S, Index));
            --  Ada.Text_IO.New_Line;
            V.Put_Character (Wide_Character'Val (B));
            Index := Index + 1;
            To_Do := To_Do - 1;
         elsif (B and 16#e0#) = 16#c0# then
            if To_Do >= 2 then
               Two_Bytes (1) :=
                  Ada.Strings.Unbounded.Element (S, Index);
               Two_Bytes (2) :=
                  Ada.Strings.Unbounded.Element (S, Index + 1);

               begin

                  W := Ada.Strings.UTF_Encoding.Wide_Strings.Decode (
                     Two_Bytes)(1);

                  --
                  --  Ada.Text_IO.Put ("View_Text_IO: ");
                  --  Ada.Wide_Text_IO.Put (W);
                  --  Ada.Integer_Text_IO.Put (
                  --     Wide_Character'Pos (W), Base => 16);
                  --  Ada.Text_IO.New_Line;
                  --

                  --
                  --  OE ligature ought to be handled at a different layer
                  --

                  if W = Wide_Character'Val (16#0152#) then
                     V.Put_Character ('O');
                     V.Put_Character ('E');
                  elsif W = Wide_Character'Val (16#0153#) then
                     V.Put_Character ('o');
                     V.Put_Character ('e');
                  else
                     V.Put_Character (W);
                  end if;

               exception

                  when Ada.Strings.UTF_Encoding.Encoding_Error =>
                     Ada.Text_IO.Put_Line ("Invalid UTF8 encoding");
               end;

               Index := Index + 2;
               To_Do := To_Do - 2;
            else
               To_Do := 0;
            end if;
         elsif (B and 16#f0#) = 16#e0# then
            if To_Do >= 3 then
               Three_Bytes (1) :=
                  Ada.Strings.Unbounded.Element (S, Index);
               Three_Bytes (2) :=
                  Ada.Strings.Unbounded.Element (S, Index + 1);
               Three_Bytes (3) :=
                  Ada.Strings.Unbounded.Element (S, Index + 2);

               begin

               W := Ada.Strings.UTF_Encoding.Wide_Strings.Decode (
                  Three_Bytes)(1);
               --  Ada.Text_IO.Put ("View_Text_IO: ");
               --  Ada.Wide_Text_IO.Put (W);
               --  Ada.Text_IO.New_Line;
               if W = Punctuation.Em_Dash then

                  --
                  --  Em_Dash is handled here because it isn't suitable for a
                  --  fixed width terminal font and is replaced with two
                  --  characters. Other substitutions (e.g directional
                  --  quotation marks) are handled during Unicode to EBCDIC
                  --  conversion.
                  --

                  V.Put_Character ('-');
                  V.Put_Character ('-');
               elsif W >= Wide_Character'Val (16#fe00#) and
                  W <= Wide_Character'Val (16#fe0f#)
               then

                  --
                  --  Ignore Unicode variation selectors.
                  --  As luck would have it, none of the Code Page 310
                  --  characters need variation selectors.
                  --  (Left Right Arrow has an emoji variant, but isn't in
                  --  Code Page 310.)
                  --

                  null;
               else
                  V.Put_Character (W);
               end if;

               exception

                  when Ada.Strings.UTF_Encoding.Encoding_Error =>
                     Ada.Text_IO.Put_Line ("Invalid UTF8 encoding");

               end;

               Index := Index + 3;
               To_Do := To_Do - 3;
            else
               To_Do := 0;
            end if;
         else
            if To_Do >= 4 then
               Four_Bytes (1) :=
                  Ada.Strings.Unbounded.Element (S, Index);
               Four_Bytes (2) :=
                  Ada.Strings.Unbounded.Element (S, Index + 1);
               Four_Bytes (3) :=
                  Ada.Strings.Unbounded.Element (S, Index + 2);
               Four_Bytes (4) :=
                  Ada.Strings.Unbounded.Element (S, Index + 3);
               begin
                  declare
                     WWS : Wide_Wide_String :=
                        Ada.Strings.UTF_Encoding.Wide_Wide_Strings.Decode (
                        Four_Bytes);
                  begin
                     Ada.Text_IO.Put ("4 byte character: ");
                     Ada.Integer_Text_IO.Put (
                        Wide_Wide_Character'Pos (WWS (1)),
                        Base => 16);
                     Ada.Text_IO.New_Line;
                  end;

               exception

                  when Ada.Strings.UTF_Encoding.Encoding_Error =>
                     Ada.Text_IO.Put_Line ("Invalid UTF8 encoding");

               end;

               V.Put_Character ('?');
               Index := Index + 4;
               To_Do := To_Do - 4;
            else
               To_Do := 0;
            end if;
         end if;
      end loop;

   end Put;

end View_Text_IO;
