with Byte_Vectors;

package Telnet.Event_Handlers is

   type Handler is abstract tagged null record;

   procedure To_Physical (
      V : Handler;
      Bytes_Out : in out Byte_Vectors.Vector) is abstract;

   procedure From_Physical (
      V : in out Handler;
      Bytes_In : Byte_Vectors.Vector) is abstract;

   procedure Initialize (
      V : in out Handler) is abstract;

end Telnet.Event_Handlers;
