with Ada.Text_IO;
with Buffer;
with Code_Page_500;
with IBM_3270;

package body Test_Break_Handlers is

  Screen_Message : Buffer.Byte_Array := (
      IBM_3270.IBM_Write_Erase,
      IBM_3270.WCC_Go_Ahead);

  Screen_Message_No_GA : Buffer.Byte_Array := (
      IBM_3270.IBM_Write_Erase,
      0);

   procedure To_Physical (
      V         : Test_Break_Handler;
      Bytes_Out : in out Byte_Vectors.Vector;
      Go_Ahead  : in out Boolean) is
   begin

      if V.Counter = 0 then
         for J in Screen_Message'Range loop
            Bytes_Out.Append (Screen_Message (J));
         end loop;
         Code_Page_500.Append (Bytes_Out, "Press the ENTER key");
         Go_Ahead := True;
      else
         for J in Screen_Message'Range loop
            Bytes_Out.Append (Screen_Message_No_GA (J));
         end loop;
         Code_Page_500.Append (Bytes_Out, "Press the ATTN key");
         Go_Ahead := False;
     end if;

   end To_Physical;

   procedure From_Physical (
      V        : in out Test_Break_Handler;
      Bytes_In : Byte_Vectors.Vector) is
   begin

      Ada.Text_IO.Put_Line ("From_Physical called");
      V.Counter := V.Counter + 1;

   end From_Physical;

   procedure Break (V : in out Test_Break_Handler) is
   begin

      Ada.Text_IO.Put_Line ("Break called");
      V.Break_Received := True;

   end Break;

   procedure Initialize (V : in out Test_Break_Handler) is
   begin

      null;

   end;

   procedure Set_RX_TX (
      V  : in out Test_Break_Handler;
      RX : access Buffer_Queues.Queue;
      TX : access Buffer_Queues.Queue) is
   begin

      null;

   end Set_RX_TX;

end Test_Break_Handlers;
