with Byte_Vectors;
with Buffer_Queues;
with Telnet.Event_Handlers;
with Views;
with Pageable_Views;

package IBM_3270_Event_Handlers is

   type Panel_Type is (Null_Panel, Menu_Panel, Split_Panel);

   type IBM_3270_Handler is new Telnet.Event_Handlers.Handler with record
      State    : Panel_Type := Null_Panel;
      Current  : Views.View_Access;
      Pageable : Pageable_Views.Pageable_Access;
      RX2      : access Buffer_Queues.Queue;
      TX2      : access Buffer_Queues.Queue;
   end record;

   procedure To_Physical (
      V         : IBM_3270_Handler;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure From_Physical (
      V        : in out IBM_3270_Handler;
      Bytes_In : Byte_Vectors.Vector);

   procedure Initialize (V : in out IBM_3270_Handler);

   procedure Set_RX_TX (
      V  : in out IBM_3270_Handler;
      RX : access Buffer_Queues.Queue;
      TX : access Buffer_Queues.Queue);

end IBM_3270_Event_Handlers;
