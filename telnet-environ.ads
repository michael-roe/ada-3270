with Buffer; use type Buffer.Byte;
with Byte_Vectors;
with Telnet_Strings;

package Telnet.Environ is

   --
   --  Defined in RFC 1572, TELNET Environment Option
   --

   Is_Cmd   : constant Buffer.Byte := 0; --  "Is" is a reserved word in Ada
   Send_Cmd : constant Buffer.Byte := 1;
   Info_Cmd : constant Buffer.Byte := 2;

   Var_Tag      : constant Buffer.Byte := 0;
   Value_Tag    : constant Buffer.Byte := 1;
   Esc_Tag      : constant Buffer.Byte := 2;
   User_Var_Tag : constant Buffer.Byte := 3;

   --
   --  Defined in RFC 2877, 5250 TELNET Enhancements
   --

   Device_Name_Str   : String := "DEVNAME";
   Keyboard_Type_Str : String := "KBDTYPE";
   Code_Page_Str     : String := "CODEPAGE";
   Charset_Str       : String := "CHARSET";

   generic

      with procedure Callback (
        N : Telnet_Strings.Bounded_String;
        V : Telnet_Strings.Bounded_String;
        User_Variable : Boolean);

      with procedure Callback_Undef (
         N : Telnet_Strings.Bounded_String;
         User_Variable : Boolean);

   procedure Parse (V : Byte_Vectors.Vector);

end Telnet.Environ;
