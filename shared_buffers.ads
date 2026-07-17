with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Streams;
use Ada.Streams;
with GNAT.Sockets;
use GNAT.Sockets;
with Buffer; use type Buffer.Byte;
with Buffer_Queues;
with Telnet.Workers;

package Shared_Buffers is

   Terminal_Socket : aliased Socket_Type;

   RX : aliased Buffer_Queues.Queue;

   TX : aliased Buffer_Queues.Queue;

   Backend_Session_Socket : aliased Socket_Type;

   RX2 : aliased Buffer_Queues.Queue;

   TX2 : aliased Buffer_Queues.Queue;

end Shared_Buffers;
