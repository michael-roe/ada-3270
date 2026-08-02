with Byte_Vectors;
with Code_Pages;

package Telnet.Event_Handlers is

   type Handler is abstract tagged null record;

   procedure To_Physical (
      V         : in out Handler;
      Bytes_Out : in out Byte_Vectors.Vector;
      P         : Code_Pages.Code_Page_Access;
      Go_Ahead  : in out Boolean) is abstract;

   procedure From_Physical (
      V        : in out Handler;
      Bytes_In : Byte_Vectors.Vector;
      P        : Code_Pages.Code_Page_Access) is abstract;

   procedure Break (V : in out Handler) is abstract;

   procedure Initialize (
      V : in out Handler) is abstract;

   type Handler_Access is access all Handler'Class;

end Telnet.Event_Handlers;
