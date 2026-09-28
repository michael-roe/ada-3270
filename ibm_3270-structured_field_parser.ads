with Byte_Vectors;
with IBM_3270_Orders;
with IBM_3270.Drivers;

package IBM_3270.Structured_Field_Parser is

   procedure Parse (Bytes_In : Byte_Vectors.Vector;
      D : IBM_3270.Drivers.Driver_Access);

end IBM_3270.Structured_Field_Parser;
