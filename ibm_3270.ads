with Buffer; use type Buffer.Byte;

package IBM_3270 is

   --
   --  Bits in the Write Control Character field
   --

   WCC_MDT      : constant Buffer.Byte := 16#1#;
   WCC_Go_Ahead : constant Buffer.Byte := 16#2#;
   WCC_Bell     : constant Buffer.Byte := 16#4#;
   WCC_Print    : constant Buffer.Byte := 16#8#;
   WCC_Parity   : constant Buffer.Byte := 16#80#;

   IBM_Write            : constant Buffer.Byte := 16#F1#;
   IBM_Read_Buffer      : constant Buffer.Byte := 16#F2#;
   IBM_Write_Structured : constant Buffer.Byte := 16#F3#;
   IBM_Write_Erase      : constant Buffer.Byte := 16#F5#;
   IBM_Read_Modified    : constant Buffer.Byte := 16#F6#;

   IBM_Write_Erase_Alternate : constant Buffer.Byte := 16#7E#;

   AID_PA1   : constant Buffer.Byte := 16#6c#;
   AID_Clear : constant Buffer.Byte := 16#6d#;
   AID_PA2   : constant Buffer.Byte := 16#6e#;
   AID_PA3   : constant Buffer.Byte := 16#6b#;
   AID_PF10  : constant Buffer.Byte := 16#7a#;
   AID_PF11  : constant Buffer.Byte := 16#7b#;
   AID_PF12  : constant Buffer.Byte := 16#7c#;
   AID_Enter : constant Buffer.Byte := 16#7d#;
   AID_CrSel : constant Buffer.Byte := 16#7e#;
   AID_PF1   : constant Buffer.Byte := 16#f1#;
   AID_PF2   : constant Buffer.Byte := 16#f2#;
   AID_PF3   : constant Buffer.Byte := 16#f3#;
   AID_PF4   : constant Buffer.Byte := 16#f4#;
   AID_PF5   : constant Buffer.Byte := 16#f5#;
   AID_PF6   : constant Buffer.Byte := 16#f6#;
   AID_PF7   : constant Buffer.Byte := 16#f7#;
   AID_PF8   : constant Buffer.Byte := 16#f8#;
   AID_PF9   : constant Buffer.Byte := 16#f9#;

   Graphic_Escape     : constant Buffer.Byte := 16#08#;
   Set_Buffer_Address : constant Buffer.Byte := 16#11#;
   Insert_Cursor      : constant Buffer.Byte := 16#13#;
   Duplicate          : constant Buffer.Byte := 16#1c#;
   Start_Field        : constant Buffer.Byte := 16#1d#;
   Field_Mark         : constant Buffer.Byte := 16#1e#;

end IBM_3270;
