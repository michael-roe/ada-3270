with Byte_Vectors;

package IBM_3270.Output_Stream is

   --
   --  Output_Stream is only used to construct test cases (it does not
   --  form part of the system under test), and so by usual coverage
   --  test conventions  we do not full test coverage of Output_Stream.
   --

   generic

      with procedure Update_Field (X : Natural; Y : Natural);

   procedure Parse (
      Bytes_Out : Byte_Vectors.Vector);

   --
   --  Parse parses an IBM 3270 output stream, keeping track of where the
   --  screen cursor would be. It calls Update_Field with the current cursor
   --  address whenever a Start_Field order is encountered.
   --

end IBM_3270.Output_Stream;
