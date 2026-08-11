with Ada.Characters.Conversions;
with Ada.Strings.UTF_Encoding;
with Ada.Strings.UTF_Encoding.Strings;
with Ada.Strings.UTF_Encoding.Wide_Strings;
with Ada.Text_IO;
with Ada.Wide_Text_IO;
with Ada.Integer_Text_IO;
with Buffer;
use type Buffer.Byte;

package body View_Text_IO is

   procedure Put (
      V : Outputable_Views.Outputable_Access;
      S : Ada.Strings.Unbounded.Unbounded_String) is
      B : Buffer.Byte;
      Two_Bytes : Ada.Strings.UTF_Encoding.UTF_8_String := "  ";
      Three_Bytes : Ada.Strings.UTF_Encoding.UTF_8_String := "   ";
      W : Wide_Character;
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
               W := Ada.Strings.UTF_Encoding.Wide_Strings.Decode (
                  Two_Bytes)(1);
               --  Ada.Text_IO.Put ("View_Text_IO: ");
               --  Ada.Wide_Text_IO.Put (W);
               --  Ada.Integer_Text_IO.Put (Wide_Character'Pos (W), Base => 16);
               --  Ada.Text_IO.New_Line;
               V.Put_Character (W);
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
               W := Ada.Strings.UTF_Encoding.Wide_Strings.Decode (
                  Three_Bytes)(1);
               --  Ada.Text_IO.Put ("View_Text_IO: ");
               --  Ada.Wide_Text_IO.Put (W);
               --  Ada.Text_IO.New_Line;
               V.Put_Character (W);
               Index := Index + 3;
               To_Do := To_Do - 3;
            else
               To_Do := 0;
            end if;
         else
            Ada.Text_IO.Put_Line ("Longer UTF8 sequences not handled");
            if To_Do >= 4 then
               Index := Index + 4;
               To_Do := To_Do - 4;
            else
               To_Do := 0;
            end if;
         end if;
      end loop;

   end Put;

end View_Text_IO;
