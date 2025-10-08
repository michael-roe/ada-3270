with Buffer;

package body Telnet.Workers is

   task body Worker is
      C : Buffer.Byte;
   begin
      loop
         RX.Dequeue (C);
         TX.Enqueue (C);
      end loop;
   end Worker;

end Telnet.Workers;
