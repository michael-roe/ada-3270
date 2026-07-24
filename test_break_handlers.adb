with Ada.Text_IO;
with Buffer;
with Code_Page_500;
with IBM_3270;
with IBM_3270_Orders;

package body Test_Break_Handlers is

  Screen_Message : Buffer.Byte_Array := (
      IBM_3270.IBM_Write_Erase,
      IBM_3270.WCC_Go_Ahead);

  Screen_Message_No_GA : Buffer.Byte_Array := (
      IBM_3270.IBM_Write_Erase,
      0);

   procedure To_Physical (
      V         : in out Test_Break_Handler;
      Bytes_Out : in out Byte_Vectors.Vector;
      Go_Ahead  : in out Boolean) is
   begin

      if V.Counter = 0 then
         for J in Screen_Message'Range loop
            Bytes_Out.Append (Screen_Message (J));
         end loop;
         IBM_3270_Orders.Start_Field (Bytes_Out, True, IBM_3270_Orders.Highlighted);
         Code_Page_500.Append (Bytes_Out, "Press the ENTER key");
         IBM_3270_Orders.Start_Field (Bytes_Out, True, IBM_3270_Orders.Normal_Text);
         Go_Ahead := True;
      else
         for J in Screen_Message'Range loop
            Bytes_Out.Append (Screen_Message_No_GA (J));
         end loop;
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 0);
         IBM_3270_Orders.Start_Field (Bytes_Out, True, IBM_3270_Orders.Highlighted);
         Code_Page_500.Append (Bytes_Out, "Press the ATTN key");
         IBM_3270_Orders.Start_Field (Bytes_Out, True, IBM_3270_Orders.Normal_Text);
         IBM_3270_Orders.Set_Buffer_Address (Bytes_Out, 0, 2);
         Code_Page_500.Append (Bytes_Out, "[");
         Code_Page_500.Append (Bytes_Out, Natural'Wide_Image (V.Counter));
         Code_Page_500.Append (Bytes_Out, "]");
         Go_Ahead := False;

         delay 2.0;

      end if;

      V.Counter := V.Counter + 1;

   end To_Physical;

   procedure From_Physical (
      V        : in out Test_Break_Handler;
      Bytes_In : Byte_Vectors.Vector) is
   begin

      Ada.Text_IO.Put_Line ("From_Physical called");

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
