with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Byte_Text_IO;

package body IBM_3270.Structured_Field_Parser is

   procedure Parse_Character_Set (
      Bytes_In : Byte_Vectors.Vector;
      Index : Natural;
      Length : Natural);

   procedure Parse_Highlighting (
      Bytes_In : Byte_Vectors.Vector;
      Index : Natural;
      Length : Natural);

   procedure Parse_Reply_Modes (
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

      for J in 0 .. Descriptor_Count - 1 loop
         Code_Page := 256 * Natural (Bytes_In.Element (
            Index + Header_Length + J * Descriptor_Length + 5)) +
            Natural (Bytes_In.Element (
               Index + Header_Length + J * Descriptor_Length + 6));
         Update_Code_Page (Code_Page);
      end loop;

   end Parse_Character_Set;

   procedure Parse_Highlighting (
      Bytes_In : Byte_Vectors.Vector;
      Index : Natural;
      Length : Natural) is
      Descriptors : Natural;
      B : Buffer.Byte;
   begin

      if Length < 5 then
         return;
      end if;

      Descriptors := Natural (Bytes_In.Element (Index + 4));

      if Length < 2*Descriptors + 5 then
         return;
      end if;

      for J in 0 .. Descriptors - 1 loop
         B := Bytes_In.Element (Index + 2*J + 6);
         if B = 16#F0# then
            Update_Highlighting (IBM_3270_Orders.Not_Highlighted);
         elsif B = 16#F1# then
            Update_Highlighting (IBM_3270_Orders.Blink_Highlighted);
         elsif B = 16#F2# then
            Update_Highlighting (IBM_3270_Orders.Reverse_Video_Highlighted);
         elsif B = 16#F4# then
            Update_Highlighting (IBM_3270_Orders.Underscore_Highlighted);
         elsif B = 16#F8# then
            Update_Highlighting (IBM_3270_Orders.Intensity_Highlighted);
         end if;
      end loop;

   end Parse_Highlighting;

   procedure Parse_Reply_Modes (
      Bytes_In : Byte_Vectors.Vector;
      Index : Natural;
      Length : Natural) is
   begin

      for J in 4 .. Length - 1 loop
         if Bytes_In.Element (Index + J) < 3 then
            Update_Reply_Mode (IBM_3270_Orders.Reply_Mode'Val (Bytes_In.Element (Index + J)));
         end if;
      end loop;

   end Parse_Reply_Modes;

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
            if Bytes_In.Element (Index + 2) = 16#81# then
               if Bytes_In.Element (Index + 3) = 16#85# then
                  Parse_Character_Set (Bytes_In, Index, Length);
               elsif Bytes_In.Element (Index + 3) = 16#87# then
                  Parse_Highlighting (Bytes_In, Index, Length);
               elsif Bytes_In.Element (Index + 3) = 16#88# then
                  Parse_Reply_Modes (Bytes_In, Index, Length);
               end if;
            end if;
         end if;

         To_Do := To_Do - Length;
         Index := Index + Length;

      end loop;

   end Parse;

end IBM_3270.Structured_Field_Parser;
