with Ada.Text_IO;
with IBM_3270;
with IBM_3270_Orders;
with Buffer;
use type Buffer.Byte;

package body Input_Stream is

   procedure Parse (Bytes_In : Byte_Vectors.Vector) is
      To_Do : Natural;
      Index : Natural;
      X : Natural;
      Y : Natural;
   begin
      To_Do := Bytes_In.Last_Index - Bytes_In.First_Index + 1;
      Index := Bytes_In.First_Index;
      while To_Do /= 0 loop
         case Bytes_In.Element (Index) is
            when IBM_3270.Set_Buffer_Address =>
               if To_Do >= 3 then
                  IBM_3270_Orders.To_Buffer_Address (
                     Bytes_In.Element (Index + 1),
                     Bytes_In.Element (Index + 2),
                     X,
                     Y);
                  Callback (X, Y);
                  To_Do := To_Do - 3;
                  Index := Index + 3;
               else
                  To_Do := 0;
               end if;
            when IBM_3270.Graphic_Escape =>
               if To_Do >= 2 then
                  To_Do := To_Do - 2;
               else
                  To_Do := 0;
               end if;
            when others =>
               To_Do := To_Do - 1;
               Index := Index + 1;
            end case;
      end loop;
   end Parse;

end Input_Stream;
