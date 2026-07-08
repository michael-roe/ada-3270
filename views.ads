with Byte_Vectors;

package Views is

  type View is abstract tagged null record;

  procedure To_Physical (
     V : View;
     Bytes_Out: in out Byte_Vectors.Vector) is abstract;

end Views;
