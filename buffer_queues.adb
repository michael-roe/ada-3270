with Buffer; use Buffer;

package body Buffer_Queues is

   protected body Queue is

   entry Enqueue (New_Item : Buffer.Byte) when not Is_Full (Container) is
      Success : Boolean;
   begin
      Success := Buffer.Enqueue_Tail (Container, New_Item);
   end Enqueue;

   entry Dequeue (Element : out Buffer.Byte) when not Is_Empty (Container) is
      Success : Boolean;
   begin
      Success := Buffer.Dequeue_Head (Container, Element);
   end Dequeue;

   function Current_Use return Count_Type is
   begin
      return Current_Use (Container);
   end Current_Use;

   function Peak_Use return Count_Type is
   begin
      return Peak_Use (Container);
   end Peak_Use;

   function Is_Empty return Boolean is
   begin
      return Is_Empty (Container);
   end Is_Empty;

   procedure Clear is
   begin
      Clear (Container);
   end Clear;

   end Queue;

end Buffer_Queues;
