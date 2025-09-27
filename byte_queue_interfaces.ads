with Ada.Containers.Synchronized_Queue_Interfaces;
with Buffer;

package Byte_Queue_Interfaces is
   new Ada.Containers.Synchronized_Queue_Interfaces
      (Element_Type => Buffer.Byte);
