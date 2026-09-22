with Ada.Text_IO;
with Ada.Wide_Text_IO;
with Ada.Strings;
with Byte_Text_IO;
with Code_Page_500;
with Code_Page_310;
with IBM_3270;
with IBM_3270_Orders;
with Buffer;
use type Buffer.Byte;
with Lines;
with Views;

package body IBM_3270.Input_Stream is

   P : Code_Page_500.Page_500;

   procedure Parse (
      V : in out Views.View'Class;
      P : Code_Pages.Code_Page_Access;
      Bytes_In : Byte_Vectors.Vector) is
      L : Lines.Bounded_Wide_String;
      To_Do : Natural;
      Index : Natural;
      X : Natural;
      Y : Natural;
      First_Field : Boolean;
      Attribute_Count : Natural;
   begin
      To_Do := Bytes_In.Last_Index - Bytes_In.First_Index + 1;
      Index := Bytes_In.First_Index;
      First_Field := True;
      X := 0;
      Y := 0;

      if To_Do >= 1 then
         Views.Update_AID (V, Bytes_In.Element (Index));
      else
         Views.Update_AID (V, 0);
      end if;

      if To_Do >= 3 then

         IBM_3270_Orders.To_Buffer_Address (
            Bytes_In.Element (Index + 1),
            Bytes_In.Element (Index + 2),
            X,
            Y);

         Views.Update_Cursor (V, X, Y);

         --
         --  Skip over the Attention ID and the cursor address
         --
         To_Do := To_Do - 3;
         Index := Index + 3;

         Lines.Set_Bounded_Wide_String (L, "");

         while To_Do /= 0 loop
            case Bytes_In.Element (Index) is
               when IBM_3270.Set_Buffer_Address =>
                  if not First_Field then
                     Lines.Trim (L, Ada.Strings.Right);
                     Views.Update_Field (V, X, Y, L);
                     Lines.Set_Bounded_Wide_String (L, "");
                  end if;
                  if To_Do >= 3 then
                     IBM_3270_Orders.To_Buffer_Address (
                        Bytes_In.Element (Index + 1),
                        Bytes_In.Element (Index + 2),
                        X,
                        Y);
                     To_Do := To_Do - 3;
                     Index := Index + 3;
                     First_Field := False;
                  else
                     To_Do := 0;
                  end if;
               when IBM_3270.Graphic_Escape =>
                  if To_Do >= 2 then
                     Lines.Append (
                        L,
                        Code_Page_310.To_Wide_Character (
                           Bytes_In.Element (Index + 1)),
                           Ada.Strings.Right);
                     To_Do := To_Do - 2;
                     Index := Index + 2;
                  else
                     To_Do := 0;
                  end if;
               when IBM_3270.Duplicate =>
                  To_Do := To_Do - 1;
                  Index := Index + 1;
               when IBM_3270.Field_Mark =>
                  To_Do := To_Do - 1;
                  Index := Index + 1;
               when IBM_3270.Start_Field_Extended =>
                  Ada.Text_IO.Put_Line ("Input_Stream: Start Field Extended");
                  if To_Do >= 2 then
                     Attribute_Count := Natural (Bytes_In.Element (Index + 1));
                     if To_Do >= 2 + 2 * Attribute_Count then
                        for J in 0 .. Attribute_Count - 1 loop
                           case Bytes_In.Element (Index + 2 * J + 2) is
                              when IBM_3270.Attribute_Basic =>
                                 Ada.Text_IO.Put_Line ("Basic");
                              when IBM_3270.Attribute_Highlight =>
                                 Ada.Text_IO.Put_Line ("Highlight");
                              when IBM_3270.Attribute_Foreground_Color =>
                                 Ada.Text_IO.Put_Line ("Foreground Color");
                              when IBM_3270.Attribute_Background_Color =>
                                 Ada.Text_IO.Put_Line ("Background Color");
                              when IBM_3270.Attribute_Validation =>
                                 Ada.Text_IO.Put_Line ("Validation");
                              when others =>
                                 Byte_Text_IO.Put (Bytes_In.Element (
                                    Index + 2 * J + 2), Base => 16);
                                 Ada.Text_IO.New_Line;
                           end case;
                        end loop;
                        To_Do := To_Do - (2 + 2 * Attribute_Count);
                        Index := Index + 2 + 2 * Attribute_Count;
                     else
                        To_Do := 0;
                     end if;
                  else
                     To_Do := 0;
                  end if;
               when IBM_3270.Set_Attribute =>
                  Ada.Text_IO.Put_Line ("Input_Stream: Set Attribute");
                  if To_Do >= 3 then
                     To_Do := To_Do - 3;
                     Index := Index + 3;
                  else
                     To_Do := 0;
                  end if;
               when others =>
                  Lines.Append (
                     L,
                     P.To_Wide_Character (
                        Bytes_In.Element (Index)),
                     Ada.Strings.Right);
                  To_Do := To_Do - 1;
                  Index := Index + 1;
            end case;
         end loop;
         if not First_Field then
            Lines.Trim (L, Ada.Strings.Right);
            Views.Update_Field (V, X, Y, L);
         end if;
      end if;
   end Parse;

end IBM_3270.Input_Stream;
