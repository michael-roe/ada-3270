with Byte_Vectors;
with IBM_3270_Orders;

generic

   with procedure Update_Code_Page (Code_Page : Integer);

   with procedure Update_Highlighting (
      Highlight : IBM_3270_Orders.Highlighting);

   with procedure Update_Reply_Mode (
      Reply_Mode : IBM_3270_Orders.Reply_Mode);

package IBM_3270.Structured_Field_Parser is

   procedure Parse (Bytes_In : Byte_Vectors.Vector);

end IBM_3270.Structured_Field_Parser;
