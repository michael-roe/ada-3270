with Byte_Vectors;
with Telnet.Options;

package body Telnet.Environ.Tests is

   Example_Option : array (Integer range 1 .. 15) of Buffer.Byte := (
      16#27#, 16#0#, 16#3#, 16#43#,
      16#4F#, 16#44#, 16#45#, 16#50#,
      16#41#, 16#47#, 16#45#, 16#1#,
      16#35#, 16#30#, 16#30#);

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

      Parse (Bytes_In);

   end Test_User_Variable;

   procedure Test_System_Variable (T : in out Test_Cases.Test_Case'Class) is
      Bytes_In : Byte_Vectors.Vector;
   begin

      Append_Header (Bytes_In);
      Append_System_Variable (Bytes_In, "USER", "guest");

      Parse (Bytes_In);

   end Test_System_Variable;

   procedure Test_Two_Variables (T : in out Test_Cases.Test_Case'Class) is
      Bytes_In : Byte_Vectors.Vector;
   begin

      Append_Header (Bytes_In);
      Append_User_Variable (Bytes_In, "CODEPAGE", "500");
      Append_User_Variable (Bytes_In, "KBDTYPE", "USI");

      Parse (Bytes_In);

   end Test_Two_Variables;

   procedure Test_Null_Value (T : in out Test_Cases.Test_Case'Class) is
      Bytes_In : Byte_Vectors.Vector;
   begin

      Append_Header (Bytes_In);
      Append_User_Variable (Bytes_In, "EMPTY", "");

      Parse (Bytes_In);

   end Test_Null_Value;

   procedure Test_Null_First (T : in out Test_Cases.Test_Case'Class) is
      Bytes_In : Byte_Vectors.Vector;
   begin

      Append_Header (Bytes_In);
      Append_User_Variable (Bytes_In, "EMPTY", "");
      Append_User_Variable (Bytes_In, "CODEPAGE", "500");

      Parse (Bytes_In);

   end Test_Null_First;

   procedure Test_Null_Name (T : in out Test_Cases.Test_Case'Class) is
      Bytes_In : Byte_Vectors.Vector;
   begin

      Append_Header (Bytes_In);
      Append_User_Variable (Bytes_In, "", "EMPTY");

      Parse (Bytes_In);

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

      Parse (Bytes_In);

   end Test_Name_Overflow;

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

   end Register_Tests;

   function Name (T : Environ_Test) return Message_String is
   begin
      return Format ("Telnet.Environ.Tests");
   end Name;

end Telnet.Environ.Tests;
