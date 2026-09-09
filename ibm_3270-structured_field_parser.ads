with Byte_Vectors;

generic

   with procedure Update_Code_Page (Code_Page : Integer);

package IBM_3270.Structured_Field_Parser is

   procedure Parse (Bytes_In : Byte_Vectors.Vector);

end IBM_3270.Structured_Field_Parser;
