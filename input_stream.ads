with Byte_Vectors;
with Lines;
with Views;
with Code_Pages;

package Input_Stream is

   procedure Parse (
      V : in out Views.View'Class;
      P : Code_Pages.Code_Page_Access;
      Bytes_In : Byte_Vectors.Vector);

end Input_Stream;
