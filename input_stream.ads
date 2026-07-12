with Byte_Vectors;
with Lines;

package Input_Stream is

   generic 
      with procedure Callback (X : Integer; Y : Integer; L : Lines.Bounded_Wide_String);
   procedure Parse (Bytes_In : Byte_Vectors.Vector);

end Input_Stream;
