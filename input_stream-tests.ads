with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;
with Buffer;
with Views;
with Lines;

package Input_Stream.Tests is

   type Test_View is new Views.View with record
      AID         : Buffer.Byte;
      Title       : Lines.Bounded_Wide_String;
      AID_Set     : Boolean := False;
      Cursor_X    : Natural := 0;
      Cursor_Y    : Natural := 0;
      Cursor_Set  : Boolean := False;
      Last_X      : Natural := 0;
      Last_Y      : Natural := 0;
      First_Field : Lines.Bounded_Wide_String;
      Last_Field  : Lines.Bounded_Wide_String;
      Field_Count : Natural := 0;
      Alternate_Code_Page : Boolean := False;
   end record;

   --
   --  Test_View is only used by tests. It records AID of the last
   --  Update_AID call it has received, the X and Y coordinates
   --  of the last Update_Cursor and Update_Field calls that it has received,
   --  the Field parameter of the last Update_Field call, the number of times
   --  Update_Field has been called, and whether Update_AID or Update_Cursor
   --  have been called.
   --

   procedure To_Physical (
      V : Test_View;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure From_Physical (
      V : in out Test_View;
      Bytes_In : Byte_Vectors.Vector);

   procedure Update_AID (
      V : in out Test_View;
      AID : Buffer.Byte);

   procedure Update_Cursor (
      V : in out Test_View;
      X : Natural;
      Y : Natural);

   procedure Update_Field (
      V : in out Test_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String);

   function Get_AID (V : Test_View) return Buffer.Byte;

   procedure Set_Title (
      V : in out Test_View;
      L : Lines.Bounded_Wide_String);

   type Input_Stream_Test is new Test_Cases.Test_Case with null record;

   --
   --  Additional tests that could be written
   --
   --     Field address out of range
   --     Bad characters in field address
   --     Characters before first Set Buffer Address
   --

   procedure Test_Empty_Stream (T : in out Test_Cases.Test_Case'Class);

   --
   --  Test_Empty_Stream tests an input stream containing 0 bytes. This
   --  is a protocol error.
   --

   procedure Test_Short_Read (T : in out Test_Cases.Test_Case'Class);

   --
   --  Test_Short_Read tests a "short read", an input stream containing
   --  a Attention Identifier and nothing else.
   --

   procedure Test_Cursor (T : in out Test_Cases.Test_Case'Class);

   --
   --  Test_Cursor tests an input stream containing an AID, a cursor
   --  address, and nothing else.
   --

   procedure Test_Cursor_Truncated (T : in out Test_Cases.Test_Case'Class);

   --
   --  Test_Cursor_Truncated tests an input stream that ends part way
   --  through the cursor address. This is a protocol error.
   --

   procedure Test_SBA_Truncated (T : in out Test_Cases.Test_Case'Class);

   --
   --  Test_SBA_Truncated tests an input stream that ends part way
   --  through a Set Buffer Address order. This is a protocol error.
   --

   procedure Test_GE_Truncated (T : in out Test_Cases.Test_Case'Class);

   --
   --  Test_GE_Truncated tests an input stream that ends part way
   --  through a Graphics Escape order. This is a protocol error.
   --

   procedure Test_Buffer_Address (T : in out Test_Cases.Test_Case'Class);

   --
   --  Test_Buffer_Address tests an input stream contaning an AID, a
   --  cursor address, and one field.
   --

   procedure Test_Duplicate (T : in out Test_Cases.Test_Case'Class);

   --
   --  Test_Duplicate tests an input stream containing a DUP (Duplicate)
   --  order. This is valid in the protocol, but should be ignored.
   --

   procedure Test_Field_Mark (T : in out Test_Cases.Test_Case'Class);

   --
   --  Test_Field_Marks tests an input stream containing a Field Mark
   --  order. This is (probably) a protocol violation, as FM should
   --  only appear if the terminal is in unformatted mode. It should
   --  be ignored.
   --

   procedure Test_Overflow (T : in out Test_Cases.Test_Case'Class);

   --
   --  Test_Overflow tests an input stream containing a field that is
   --  longer than expected. Fields that are too long should be truncated
   --  on the right.
   --

   procedure Test_Trim (T : in out Test_Cases.Test_Case'Class);

   --
   --  Test_Trim tests an input stream with trailing spaces at the end
   --  of the last field.
   --

   procedure Test_Two_Fields (T : in out Test_Cases.Test_Case'Class);

   --
   --  Test_Two_Fields tests an input stream containing two fields.
   --

   procedure Test_Trim_Two (T : in out Test_Cases.Test_Case'Class);

   --
   --  Test_Trim_Two tests an input stream containing two fields
   --  with padding at the end.
   --

   procedure Test_Code_Page (T : in out Test_Cases.Test_Case'Class);

   --
   --  Test_Code_Page tests an input stream encoded in code page 870.
   --

   procedure Register_Tests (T : in out Input_Stream_Test);

   function Name (T : Input_Stream_Test) return Message_String;

end Input_Stream.Tests;
