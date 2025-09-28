with Buffer; use type Buffer.Byte;

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

end Telnet.Environ;
