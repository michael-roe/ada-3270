with Buffer_Queues; use Buffer_Queues;
with Telnet.Event_Handlers;

package Telnet.Workers is

   task type Worker (
      RX : access Buffer_Queues.Queue;
      TX : access Buffer_Queues.Queue;
      RX2 : access Buffer_Queues.Queue;
      TX2 : access Buffer_Queues.Queue;
      Handler   : Telnet.Event_Handlers.Handler_Access;
      Responder : Boolean) is
      entry Connect;
   end Worker;

end Telnet.Workers;
