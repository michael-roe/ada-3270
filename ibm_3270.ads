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

   Graphic_Escape     : constant Buffer.Byte := 16#08#;
   Set_Buffer_Address : constant Buffer.Byte := 16#11#;
   Insert_Cursor      : constant Buffer.Byte := 16#13#;
   Start_Field        : constant Buffer.Byte := 16#1d#;
   Field_Mark         : constant Buffer.Byte := 16#1e#;

end IBM_3270;
