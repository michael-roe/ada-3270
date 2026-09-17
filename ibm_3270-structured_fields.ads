with Byte_Vectors;
with IBM_3270_Orders;

package IBM_3270.Structured_Fields is

   procedure Read_Partition_Query (Bytes_Out : in out Byte_Vectors.Vector);

   procedure Set_Reply_Mode (
      Bytes_Out : in out Byte_Vectors.Vector;
      Reply_Mode : IBM_3270_Orders.Reply_Mode;
      Enable_Highlight : Boolean := False;
      Enable_Color : Boolean := False;
      Enable_Symbols : Boolean := False);

end IBM_3270.Structured_Fields;
