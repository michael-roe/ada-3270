with Ada.Containers; use Ada.Containers;
with Buffer;
with Byte_Queue_Interfaces; use Byte_Queue_Interfaces;

package Buffer_Queues is

   protected type Queue is new Byte_Queue_Interfaces.Queue with

      overriding entry Enqueue (New_Item : Buffer.Byte);

      overriding entry Dequeue (Element : out Buffer.Byte);

      overriding function Current_Use return Count_Type;

      overriding function Peak_Use return Count_Type;

      procedure Clear;

   private

      Container : Buffer.T;

   end Queue;

end Buffer_Queues;
