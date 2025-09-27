package body Buffer is

   function Is_Empty (Container : T) return Boolean is
   begin
      return Container.length = 0;
   end Is_Empty;

   function Is_Full (Container : T) return Boolean is
   begin
      return Container.length = Buffer_Size;
   end Is_Full;

   function Current_Use (Container : T) return Count_Type is
   begin
      return Container.length;
   end Current_Use;

   function Peak_Use (Container : T) return Count_Type is
   begin
      return Container.Peak;
   end Peak_Use;

   procedure Clear (Container : in out T) is
   begin
      Container.length := 0;
      Container.head := 0;
      Container.tail := 0;
      Container.peak := 0;
   end Clear;

   function Enqueue_Tail (Container : in out T; b : Byte) return Boolean is
   begin
      if Container.length = Buffer_Size then
         return False;
      else
         Container.data (Container.tail) := b;
         Container.length := Container.length + 1;
         if Container.tail = Buffer_Size - 1 then
            Container.tail := 0;
         else
            Container.tail := Container.tail + 1;
         end if;
         if Container.length > Container.peak then
            Container.peak := Container.length;
         end if;
         return True;
      end if;
   end Enqueue_Tail;

   function Dequeue_Head (Container : in out T; b : in out Byte)
     return Boolean is
   begin
      if Container.length = 0 then
         return False;
      else
         b := Container.data (Container.head);
         Container.length := Container.length - 1;
         if Container.head = Buffer_Size - 1 then
            Container.head := 0;
         else
            Container.head := Container.head + 1;
         end if;
         return True;
      end if;
   end Dequeue_Head;

end Buffer;
