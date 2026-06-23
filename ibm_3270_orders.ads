with Buffer;
with Byte_Vectors;

package IBM_3270_Orders is

   procedure Set_Buffer_Address (V : in out Byte_Vectors.Vector;
      X : Integer;
      Y : Integer);

   procedure Insert_Cursor (V : in out Byte_Vectors.Vector);

   procedure Start_Field (V : in out Byte_Vectors.Vector;
      Protect : Boolean;
      Intense : Boolean);

end IBM_3270_Orders;
