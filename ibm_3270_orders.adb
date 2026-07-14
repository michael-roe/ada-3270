with Interfaces;
use type Interfaces.Unsigned_16;
with IBM_3270;
with Buffer;
use type Buffer.Byte;

package body IBM_3270_Orders is

   type Unsigned_6 is mod 2**6;

   Table : constant array (Unsigned_6) of Buffer.Byte := (
      16#40#, 16#C1#, 16#C2#, 16#C3#, 16#C4#, 16#C5#, 16#C6#, 16#C7#,
      16#C8#, 16#C9#, 16#4A#, 16#4B#, 16#4C#, 16#4D#, 16#4E#, 16#4F#,
      16#50#, 16#D1#, 16#D2#, 16#D3#, 16#D4#, 16#D5#, 16#D6#, 16#D7#,
      16#D8#, 16#D9#, 16#5A#, 16#5B#, 16#5C#, 16#5D#, 16#5E#, 16#5F#,
      16#60#, 16#61#, 16#E2#, 16#E3#, 16#E4#, 16#E5#, 16#E6#, 16#E7#,
      16#E8#, 16#E9#, 16#6A#, 16#6B#, 16#6C#, 16#6D#, 16#6E#, 16#6F#,
      16#F0#, 16#F1#, 16#F2#, 16#F3#, 16#F4#, 16#F5#, 16#F6#, 16#F7#,
      16#F8#, 16#F9#, 16#7A#, 16#7B#, 16#7C#, 16#7D#, 16#7E#, 16#7F#);

   procedure Set_Buffer_Address (V : in out Byte_Vectors.Vector;
      X : Integer;
      Y : Integer) is
      Addr : Interfaces.Unsigned_16;
   begin
      --
      --  Check that the buffer address falls within the screen size
      --  of the 3278-4. Other models had smaller screens, and we ought
      --  to check against the screen size of the current terminal.
      --
      if X >= 0 and X < 80 and Y >= 0 and Y < 44 then
         Addr := Interfaces.Unsigned_16 (X + 80*Y);
         V.Append (IBM_3270.Set_Buffer_Address);
         V.Append (Table (Unsigned_6 (Addr / 64)));
         V.Append (Table (Unsigned_6 (Addr
            and Interfaces.Unsigned_16 (16#3f#))));
      end if;
   end Set_Buffer_Address;

   procedure Insert_Cursor (V : in out Byte_Vectors.Vector) is
   begin
      V.Append (IBM_3270.Insert_Cursor);
   end Insert_Cursor;

   procedure Start_Field (V : in out Byte_Vectors.Vector;
      Protect : Boolean;
      Intense : Intensity;
      Modified : Boolean := False) is
      Attr : Buffer.Byte;
   begin
      V.Append (IBM_3270.Start_Field);
      Attr := 0;
      if Modified then
         Attr := Attr + 16#1#;
      end if;
      if Protect then
         Attr := Attr + 16#20#;
      end if;
      Attr := Attr + 4*Intensity'Pos (Intense);
      V.Append (Attr);
   end Start_Field;

   function Unpack (B : Buffer.Byte) return Natural is
   begin

      for J in Unsigned_6 loop
         if Table (J) = B then
            return Natural (J);
         end if;
      end loop;

      return 0;

   end Unpack;

   procedure To_Buffer_Address (
      C1 : Buffer.Byte;
      C2 : Buffer.Byte;
      X : out Natural;
      Y : out Natural) is
      A : Natural;
   begin
      A := 64*Unpack (C1) + Unpack (C2);
      X := A mod 80;
      Y := A / 80;
   end To_Buffer_Address;

   function Is_Short_Read (AID : Buffer.Byte) return Boolean is
   begin
      return (AID = IBM_3270.AID_Clear) or
         (AID = IBM_3270.AID_PA1) or
         (AID = IBM_3270.AID_PA2) or
         (AID = IBM_3270.AID_PA3);
   end Is_Short_Read;

end IBM_3270_Orders;
