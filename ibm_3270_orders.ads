with Buffer;
with Byte_Vectors;

package IBM_3270_Orders is

   type Intensity is (Normal_Text, Detectable, Highlighted, Hidden);

   procedure Set_Buffer_Address (V : in out Byte_Vectors.Vector;
      X : Integer;
      Y : Integer);

   procedure Insert_Cursor (V : in out Byte_Vectors.Vector);

   procedure Start_Field (V : in out Byte_Vectors.Vector;
      Protect : Boolean;
      Intense : Intensity);

end IBM_3270_Orders;
