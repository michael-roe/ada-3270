with Ada.Containers; use type Ada.Containers.Count_Type;
with Buffer;
use type Buffer.Byte;
with IBM_3270;
with IBM_3270_Orders;

package body Output_Stream is

   procedure Parse (
      Bytes_Out : Byte_Vectors.Vector) is
      Cursor_X : Natural;
      Cursor_Y : Natural;
      To_Do : Natural;
      Index : Natural;
      B : Buffer.Byte;
   begin

      Index := Bytes_Out.First_Index;
      To_Do := Bytes_Out.Last_Index - Bytes_Out.First_Index + 1;
      Cursor_X := 0;
      Cursor_Y := 0;

      while To_Do > 0 loop

         B := Bytes_Out.Element (Index);

         case B is

            when IBM_3270.Insert_Cursor =>
               To_Do := To_Do - 1;
               Index := Index + 1;

            when IBM_3270.Start_Field =>
               if To_Do >= 2 then
                  if (Bytes_Out.Element (Index + 1) and 16#20#) = 0 then
                     Update_Field (Cursor_X, Cursor_Y);
                  end if;
                  To_Do := To_Do - 1;
                  Index := Index + 1;
                  Cursor_X := Cursor_X + 1;
               else
                  To_Do := 0;
               end if;

            when IBM_3270.Set_Buffer_Address =>
               if To_Do >= 3 then
                  IBM_3270_Orders.To_Buffer_Address (
                     Bytes_Out.Element (Index + 1),
                     Bytes_Out.Element (Index + 2),
                     Cursor_X,
                     Cursor_Y);
                  To_Do := To_Do - 3;
                  Index := Index + 3;
               else
                  To_Do := 0;
               end if;

            when IBM_3270.Graphic_Escape =>
               if To_Do >= 2 then
                  To_Do := To_Do - 2;
                  Index := Index + 2;
                  Cursor_X := Cursor_X + 1;
                  if Cursor_X > 79 then
                     Cursor_X := 0;
                     Cursor_Y := Cursor_Y + 1;
                  end if;
               else
                  To_Do := 0;
               end if;

            when others =>
               To_Do := To_Do - 1;
               Index := Index + 1;
               Cursor_X := Cursor_X + 1;
               if Cursor_X > 79 then
                  Cursor_X := 0;
                  Cursor_Y := Cursor_Y + 1;
               end if;

         end case;

      end loop;

   end Parse;

end Output_Stream;
