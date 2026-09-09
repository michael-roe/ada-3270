with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Byte_Text_IO;

package body IBM_3270.Structured_Field_Parser is

   procedure Parse_Character_Set (
      Bytes_In : Byte_Vectors.Vector;
      Index : Natural;
      Length : Natural);

   procedure Parse_Character_Set (
      Bytes_In : Byte_Vectors.Vector;
      Index : Natural;
      Length : Natural) is
      Header_Length : Natural;
      Descriptor_Length : Natural;
      Descriptor_Count : Natural;
      Code_Page : Natural;
   begin

      Header_Length := 13;
      Descriptor_Length := 7;

      Descriptor_Count := (Length - Header_Length) / Descriptor_Length;

      --  Ada.Text_IO.Put ("Descriptor_Count = ");
      --  Ada.Integer_Text_IO.Put (Descriptor_Count);
      --  Ada.Text_IO.New_Line;

      for J in 0 .. Descriptor_Count - 1 loop
         --  Byte_Text_IO.Put (
         --     Bytes_In.Element (Index + Header_Length +
         --        J * Descriptor_Length)
         --  );
         Ada.Text_IO.New_Line;
         Code_Page := 256 * Natural (Bytes_In.Element (
            Index + Header_Length + J * Descriptor_Length + 5)) +
            Natural (Bytes_In.Element (
               Index + Header_Length + J * Descriptor_Length + 6));
         Update_Code_Page (Code_Page);
      end loop;

   end Parse_Character_Set;

   procedure Parse (Bytes_In : Byte_Vectors.Vector) is
      To_Do : Natural;
      Index : Natural;
      Length : Natural;
   begin

      To_Do := Natural (Bytes_In.Length);
      Index := Bytes_In.First_Index;

      To_Do := To_Do - 1;
      Index := Index + 1;

      while To_Do >= 2 loop

         Length := 256 * Natural (Bytes_In.Element (Index)) +
            Natural (Bytes_In.Element (Index + 1));

         if Length = 0 then
            exit;
         end if;

         if Length > 3 then
            if Bytes_In.Element (Index + 2) = 16#81# and
               Bytes_In.Element (Index + 3) = 16#85#
            then
               Parse_Character_Set (Bytes_In, Index, Length);
            end if;
            --  for J in 3 .. Length - 1 loop
            --     Byte_Text_IO.Put (Bytes_In.Element (Index + J), Base => 16);
            --     Ada.Text_IO.Put (" ");
            --  end loop;
            --  Ada.Text_IO.New_Line;
         end if;

         To_Do := To_Do - Length;
         Index := Index + Length;

      end loop;

   end Parse;

end IBM_3270.Structured_Field_Parser;
