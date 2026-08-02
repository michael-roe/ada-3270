with AUnit.Assertions; use AUnit.Assertions;
with Ada.Text_IO;
with Byte_Vectors;
with Telnet.Options;
with Telnet_Strings;
use type Telnet_Strings.Bounded_String;

package body Telnet.Environ.Tests is

   Example_Option : array (Integer range 1 .. 15) of Buffer.Byte := (
      16#27#, 16#0#, 16#3#, 16#43#,
      16#4F#, 16#44#, 16#45#, 16#50#,
      16#41#, 16#47#, 16#45#, 16#1#,
      16#35#, 16#30#, 16#30#);

   Name_1 : Telnet_Strings.Bounded_String;

   Value_1 : Telnet_Strings.Bounded_String;

   procedure Debug (
        N : Telnet_Strings.Bounded_String;
        V : Telnet_Strings.Bounded_String;
        User_Variable : Boolean) is
   begin

      Name_1 := N;

      Value_1 := V;
 
   end Debug;

   procedure Parse_Debug is new Parse (Callback => Debug);

   procedure Append_Header (Bytes_In : in out Byte_Vectors.Vector) is
   begin

      Bytes_In.Append (Telnet.Options.New_Environ);
      Bytes_In.Append (Telnet.Environ.Is_Cmd);
 
   end Append_Header;

   procedure Append_User_Variable (
      Bytes_In : in out Byte_Vectors.Vector;
      Name : String;
      Value : String) is
   begin

      Bytes_In.Append (User_Var_Tag);
      for J in Name'Range loop
         Bytes_In.Append (Character'Pos (Name (J)));
      end loop;

      Bytes_In.Append (Value_Tag);
      for J in Value'Range loop
         Bytes_In.Append (Character'Pos (Value (J)));
      end loop;

   end Append_User_Variable;

   procedure Append_System_Variable (
      Bytes_In : in out Byte_Vectors.Vector;
      Name : String;
      Value : String) is
   begin

      Bytes_In.Append (Var_Tag);
      for J in Name'Range loop
         Bytes_In.Append (Character'Pos (Name (J)));
      end loop;

      Bytes_In.Append (Value_Tag);
      for J in Value'Range loop
         Bytes_In.Append (Character'Pos (Value (J)));
      end loop;

   end Append_System_Variable;

   procedure Test_User_Variable (T : in out Test_Cases.Test_Case'Class) is
      Bytes_In : Byte_Vectors.Vector;
   begin

      for J in Example_Option'First .. Example_Option'Last loop
         Bytes_In.Append (Example_Option (J));
      end loop;

      Parse_Debug (Bytes_In);

      Assert (Name_1 = "CODEPAGE", "Name should be CODEPAGE");
      Assert (Value_1 = "500", "Value should be 500");

   end Test_User_Variable;

   procedure Test_System_Variable (T : in out Test_Cases.Test_Case'Class) is
      Bytes_In : Byte_Vectors.Vector;
   begin

      Append_Header (Bytes_In);
      Append_System_Variable (Bytes_In, "USER", "guest");

      Parse_Debug (Bytes_In);

      Assert (Name_1 = "USER", "Name should be USER");
      Assert (Value_1 = "guest", "Value should be guest");

   end Test_System_Variable;

   procedure Test_Two_Variables (T : in out Test_Cases.Test_Case'Class) is
      Bytes_In : Byte_Vectors.Vector;
   begin

      Append_Header (Bytes_In);
      Append_User_Variable (Bytes_In, "CODEPAGE", "500");
      Append_User_Variable (Bytes_In, "KBDTYPE", "USI");

      Parse_Debug (Bytes_In);

   end Test_Two_Variables;

   procedure Test_Null_Value (T : in out Test_Cases.Test_Case'Class) is
      Bytes_In : Byte_Vectors.Vector;
   begin

      Append_Header (Bytes_In);
      Append_User_Variable (Bytes_In, "EMPTY", "");

      Parse_Debug (Bytes_In);

      Assert (Name_1 = "EMPTY", "Name should be EMPTY");
      Assert (Value_1 = "", "Value should be null string");

   end Test_Null_Value;

   procedure Test_Null_First (T : in out Test_Cases.Test_Case'Class) is
      Bytes_In : Byte_Vectors.Vector;
   begin

      Append_Header (Bytes_In);
      Append_User_Variable (Bytes_In, "EMPTY", "");
      Append_User_Variable (Bytes_In, "CODEPAGE", "500");

      Parse_Debug (Bytes_In);

   end Test_Null_First;

   procedure Test_Null_Name (T : in out Test_Cases.Test_Case'Class) is
      Bytes_In : Byte_Vectors.Vector;
   begin

      Append_Header (Bytes_In);
      Append_User_Variable (Bytes_In, "", "EMPTY");

      Parse_Debug (Bytes_In);

      Assert (Name_1 = "", "Name should be null string");
      Assert (Value_1 = "EMPTY", "Value should be EMPTY");

   end Test_Null_Name;

   procedure Test_Name_Overflow (T : in out Test_Cases.Test_Case'Class) is
      Bytes_In : Byte_Vectors.Vector;
   begin

      Append_Header (Bytes_In);
      Bytes_In.Append (User_Var_Tag);
      for J in 1 .. 256 loop
         Bytes_In.Append (Character'Pos ('!'));
      end loop;
      Bytes_In.Append (Telnet.Environ.Value_Tag);
      Bytes_In.Append (Character'Pos ('V'));

      Parse_Debug (Bytes_In);

      Assert (Value_1 = "V", "Value should be V");

   end Test_Name_Overflow;

   procedure Test_Value_Overflow (T : in out Test_Cases.Test_Case'Class) is
      Bytes_In : Byte_Vectors.Vector;
   begin

      Append_Header (Bytes_In);
      Bytes_In.Append (User_Var_Tag);
      Bytes_In.Append (Character'Pos ('N'));
      Bytes_In.Append (Telnet.Environ.Value_Tag);
      for J in 1 .. 256 loop
         Bytes_In.Append (Character'Pos ('!'));
      end loop;

      Parse_Debug (Bytes_In);

      Assert (Name_1 = "N", "Name should be N");

   end Test_Value_Overflow;

  procedure Test_Value_Escape (T : in out Test_Cases.Test_Case'Class) is
      Bytes_In : Byte_Vectors.Vector;
   begin

      Append_Header (Bytes_In);
      Bytes_In.Append (User_Var_Tag);
      Bytes_In.Append (Character'Pos ('E'));
      Bytes_In.Append (Telnet.Environ.Value_Tag);
      Bytes_In.Append (Telnet.Environ.Esc_Tag);
      Bytes_In.Append (Telnet.Environ.Esc_Tag);

      Parse_Debug (Bytes_In);

      Assert (Name_1 = "E", "Name should be E");

      Assert (Telnet_Strings.Length (Value_1) = 1,
         "Value length should be 1");

      Assert (Telnet_Strings.Element (Value_1, 1) =
         Character'Val (Telnet.Environ.Esc_Tag),
         "Value should contain an escape tag");

   end Test_Value_Escape;

  procedure Test_Value_Var_Tag (T : in out Test_Cases.Test_Case'Class) is
      Bytes_In : Byte_Vectors.Vector;
   begin

      Append_Header (Bytes_In);
      Bytes_In.Append (User_Var_Tag);
      Bytes_In.Append (Character'Pos ('E'));
      Bytes_In.Append (Telnet.Environ.Value_Tag);
      Bytes_In.Append (Telnet.Environ.Esc_Tag);
      Bytes_In.Append (Telnet.Environ.Var_Tag);

      Parse_Debug (Bytes_In);

      Assert (Name_1 = "E", "Name should be E");

      Assert (Telnet_Strings.Length (Value_1) = 1,
         "Value length should be 1");

      Assert (Telnet_Strings.Element (Value_1, 1) =
         Character'Val (Telnet.Environ.Var_Tag),
         "Value should contain a Var tag");

   end Test_Value_Var_Tag;

   procedure Register_Tests (T : in out Environ_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_User_Variable'Access,
         "Test_User_Variable");

      Register_Routine (T, Test_System_Variable'Access,
         "Test_System_Variable");

      Register_Routine (T, Test_Two_Variables'Access,
         "Test_Two_Variables");

      Register_Routine (T, Test_Null_Value'Access,
         "Test_Null_Value");

      Register_Routine (T, Test_Null_First'Access,
         "Test_Null_First");

      Register_Routine (T, Test_Null_Name'Access,
         "Test_Null_Name");

      Register_Routine (T, Test_Name_Overflow'Access,
         "Test_Name_Overflow");

      Register_Routine (T, Test_Value_Overflow'Access,
         "Test_Value_Overflow");

      Register_Routine (T, Test_Value_Escape'Access,
         "Test_Value_Escape");

      Register_Routine (T, Test_Value_Var_Tag'Access,
         "Test_Value_Var_Tag");

   end Register_Tests;

   function Name (T : Environ_Test) return Message_String is
   begin
      return Format ("Telnet.Environ.Tests");
   end Name;

end Telnet.Environ.Tests;
