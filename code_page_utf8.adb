with Ada.Strings.UTF_Encoding;
with Ada.Strings.UTF_Encoding.Wide_Strings;

package body Code_Page_UTF8 is

   procedure Append (V : in out Byte_Vectors.Vector;
      C : Wide_Character) is
   begin

      if C < Wide_Character'Val (128) then
         V.Append (Wide_Character'Pos (C));
      else
         declare
            Encoded : Ada.Strings.UTF_Encoding.UTF_8_String :=
               Ada.Strings.UTF_Encoding.Wide_Strings.Encode ("" & C);
         begin
            for J in Encoded'Range loop
               V.Append (Character'Pos (Encoded (J)));
            end loop;
         end;
      end if;

   end Append;

end Code_Page_UTF8;
