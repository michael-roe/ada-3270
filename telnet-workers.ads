with Buffer_Queues; use Buffer_Queues;

package Telnet.Workers is

   task type Worker (
      RX : access Buffer_Queues.Queue;
      TX : access Buffer_Queues.Queue;
      RX2 : access Buffer_Queues.Queue;
      TX2 : access Buffer_Queues.Queue;
      Responder : Boolean) is
      entry Connect;
   end Worker;

end Telnet.Workers;
