package body JSON.String_Encoding is

   procedure Append (V : in out Byte_Vectors.Vector;
      C : Wide_Character) is
   begin

      if C = '\' then
         V.Append (Character'Pos ('\'));
         V.Append (Character'Pos ('\'));
      elsif C = '"' then
         V.Append (Character'Pos ('\'));
         V.Append (Character'Pos ('"'));
      else
         Code_Page_UTF8.Append (V, C);
      end if;

   end Append;

end JSON.String_Encoding;
