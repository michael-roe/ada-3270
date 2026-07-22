with Ada.Text_IO;
with Ada.Wide_Text_IO;
with Ada.Strings;
with Code_Page_500;
with Code_Page_310;
with IBM_3270;
with IBM_3270_Orders;
with Buffer;
use type Buffer.Byte;
with Lines;
with Views;

package body Input_Stream is

   procedure Parse (
      V : in out Views.View'Class;
      Bytes_In : Byte_Vectors.Vector) is
      L : Lines.Bounded_Wide_String;
      To_Do : Natural;
      Index : Natural;
      X : Natural;
      Y : Natural;
      First_Field : Boolean;
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
                  if First_Field then
                     First_Field := False;
                  else
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
               when others =>
                  Lines.Append (
                     L,
                     Code_Page_500.To_Wide_Character (
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

end Input_Stream;
