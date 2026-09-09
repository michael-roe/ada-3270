with AUnit.Assertions; use AUnit.Assertions;
with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Byte_Text_IO;
with Byte_Vectors;
with IBM_3270_Orders;
with IBM_3270.Structured_Field_Parser;

package body IBM_3270.Structured_Field_Parser_Tests is

   procedure Update_Code_Page (Code_Page : Integer);

   procedure Update_Reply_Mode (Reply_Mode : IBM_3270_Orders.Reply_Mode);

   Read_Partition_Reply : array (Integer range 0 .. 179)
      of Buffer.Byte := (
16#88#, 16#0#, 16#E#, 16#81#, 16#80#, 16#80#, 16#81#, 16#84#,
16#85#, 16#86#, 16#87#, 16#88#, 16#95#, 16#A1#, 16#A6#, 16#0#,
16#17#, 16#81#, 16#81#, 16#1#, 16#0#, 16#0#, 16#50#, 16#0#,
16#2B#, 16#1#, 16#0#, 16#A#, 16#2#, 16#E5#, 16#0#, 16#2#,
16#0#, 16#6F#, 16#9#, 16#C#, 16#D#, 16#70#, 16#0#, 16#8#,
16#81#, 16#84#, 16#0#, 16#D#, 16#70#, 16#0#, 16#0#, 16#1B#,
16#81#, 16#85#, 16#82#, 16#0#, 16#9#, 16#C#, 16#0#, 16#0#,
16#0#, 16#0#, 16#7#, 16#0#, 16#10#, 16#0#, 16#2#, 16#B9#,
16#1#, 16#F4#, 16#1#, 16#0#, 16#F1#, 16#3#, 16#C3#, 16#1#,
16#36#, 16#0#, 16#26#, 16#81#, 16#86#, 16#0#, 16#10#, 16#0#,
16#F4#, 16#F1#, 16#F1#, 16#F2#, 16#F2#, 16#F3#, 16#F3#, 16#F4#,
16#F4#, 16#F5#, 16#F5#, 16#F6#, 16#F6#, 16#F7#, 16#F7#, 16#F8#,
16#F8#, 16#F9#, 16#F9#, 16#FA#, 16#FA#, 16#FB#, 16#FB#, 16#FC#,
16#FC#, 16#FD#, 16#FD#, 16#FE#, 16#FE#, 16#FF#, 16#FF#, 16#0#,
16#F#, 16#81#, 16#87#, 16#5#, 16#0#, 16#F0#, 16#F1#, 16#F1#,
16#F2#, 16#F2#, 16#F4#, 16#F4#, 16#F8#, 16#F8#, 16#0#, 16#7#,
16#81#, 16#88#, 16#0#, 16#1#, 16#2#, 16#0#, 16#C#, 16#81#,
16#95#, 16#0#, 16#0#, 16#40#, 16#0#, 16#40#, 16#0#, 16#1#,
16#1#, 16#0#, 16#12#, 16#81#, 16#A1#, 16#0#, 16#0#, 16#0#,
16#0#, 16#0#, 16#0#, 16#0#, 16#0#, 16#6#, 16#A7#, 16#F3#,
16#F2#, 16#F7#, 16#F0#, 16#0#, 16#11#, 16#81#, 16#A6#, 16#0#,
16#0#, 16#B#, 16#1#, 16#0#, 16#0#, 16#50#, 16#0#, 16#18#,
16#0#, 16#50#, 16#0#, 16#2B#);

   Has_Page_500 : Boolean;

   Has_Page_310 : Boolean;

   Supported_Reply_Modes : array (IBM_3270_Orders.Reply_Mode) of Boolean;

   procedure Update_Code_Page (Code_Page : Integer) is
   begin

      if Code_Page = 310 then
         Has_Page_310 := True;
      elsif Code_Page = 500 then
         Has_Page_500 := True;
      end if;

   end Update_Code_Page;

   procedure Update_Reply_Mode (Reply_Mode : IBM_3270_Orders.Reply_Mode) is
   begin

      Supported_Reply_Modes (Reply_Mode) := True;

   end Update_Reply_Mode;

   package Parser is new IBM_3270.Structured_Field_Parser (
      Update_Code_Page => Update_Code_Page,
      Update_Reply_Mode => Update_Reply_Mode);

   procedure Test_Code_Page (T : in out Test_Cases.Test_Case'Class) is
      Bytes_In : Byte_Vectors.Vector;
   begin

      for J in Read_Partition_Reply'Range loop
         Bytes_In.Append (Read_Partition_Reply (J));
      end loop;

      Has_Page_310 := False;
      Has_Page_500 := False;

      for J in IBM_3270_Orders.Reply_Mode loop
         Supported_Reply_Modes (J) := False;
      end loop;

      Parser.Parse (Bytes_In);

      Assert (Has_Page_310, "Code Page 310 not reported");
      Assert (Has_Page_500, "Code Page 500 not reported");

      Assert (Supported_Reply_Modes (IBM_3270_Orders.Field_Mode),
         "Field Mode not supported");
      Assert (Supported_Reply_Modes (IBM_3270_Orders.Extended_Mode),
         "Extended Mode not supported");
      Assert (Supported_Reply_Modes (IBM_3270_Orders.Character_Mode),
         "Character Mode not supported");

   end Test_Code_Page;

   procedure Register_Tests (T : in out SF_Parser_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Code_Page'Access,
         "Test_Code_Page");

   end Register_Tests;

   function Name (T : SF_Parser_Test) return Message_String is
   begin

      return Format ("IBM_3270.Structured_Field_Parser_Tests");

   end Name;

end IBM_3270.Structured_Field_Parser_Tests;
