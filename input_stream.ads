with Byte_Vectors;
with Lines;
with Views;

package Input_Stream is

   procedure Parse (
      V : in out Views.View'Class;
      Bytes_In : Byte_Vectors.Vector);

end Input_Stream;
