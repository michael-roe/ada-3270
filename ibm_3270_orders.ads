with Buffer;
with Byte_Vectors;

package IBM_3270_Orders is

   type Intensity is (Normal_Text, Detectable, Highlighted, Hidden);

   procedure Set_Buffer_Address (V : in out Byte_Vectors.Vector;
      X : Integer;
      Y : Integer);

   --
   --   Set_Buffer_Address appends an SBA order to output stream V.
   --
   --   When the terminal receives this order, it will set the current
   --   buffer address to column X and row Y on the screen.
   --

   procedure Insert_Cursor (V : in out Byte_Vectors.Vector);

   --
   --  Insert_Cursor appends an IC order to output stream V.
   --
   --  When the terminal receives this order, it will set the position
   --  of the cursor to the current buffer address.
   --

   procedure Start_Field (V : in out Byte_Vectors.Vector;
      Protect : Boolean;
      Intense : Intensity;
      Modified : Boolean := False);

   --
   --  Start_Field appends a SF order to output stream V.
   --
   --  When the terminal receives this order, it will create a field
   --  on the screen starting at the current buffer address.
   --  If Protect is False, the field allows user input.
   --  Intense sets the intensity of the field on the screen:
   --  normal, highlighted, or hidden.
   --  "Hidden" fields do not show their contents on the screen, and
   --  can be used for password input.
   --  Detectable fields have special behavior when the Cursor Select key
   --  is pressed while the cursor is within the field.
   --  Modified sets the modified data tag; the terminal will treat this
   --  field as if its contents have been modified by the user.
   --

   procedure To_Buffer_Address (
      C1 : Buffer.Byte;
      C2 : Buffer.Byte;
      X : out Natural;
      Y : out Natural);

   --
   --  To_Buffer_Address converts the EBCDIC characters C1 and C2 into
   --  screen co-ordinates column X and row Y. It uses an IBM encoding
   --  that is similar to Base 64 (RFC 4648), except that it uses a
   --  different conversion table because (a) it's using EBCDIC rather
   --  than ASCII; and (b) it was independently invented by IBM.
   --

   function Is_Short_Read (AID : Buffer.Byte) return Boolean;

end IBM_3270_Orders;
