package body Buffer is

   function Is_Empty (Container : T) return Boolean is
   begin
      return Container.Length = 0;
   end Is_Empty;

   function Is_Full (Container : T) return Boolean is
   begin
      return Container.Length = Buffer_Size;
   end Is_Full;

   function Current_Use (Container : T) return Count_Type is
   begin
      return Container.Length;
   end Current_Use;

   function Peak_Use (Container : T) return Count_Type is
   begin
      return Container.Peak;
   end Peak_Use;

   procedure Clear (Container : in out T) is
   begin
      Container.Length := 0;
      Container.Head := 0;
      Container.Tail := 0;
      Container.Peak := 0;
   end Clear;

   function Enqueue_Tail (Container : in out T; b : Byte) return Boolean is
   begin
      if Container.Length = Buffer_Size then
         return False;
      else
         Container.Data (Container.Tail) := b;
         Container.Length := Container.Length + 1;
         if Container.Tail = Buffer_Size - 1 then
            Container.Tail := 0;
         else
            Container.Tail := Container.Tail + 1;
         end if;
         if Container.Length > Container.Peak then
            Container.Peak := Container.Length;
         end if;
         return True;
      end if;
   end Enqueue_Tail;

   function Dequeue_Head (Container : in out T; b : in out Byte)
     return Boolean is
   begin
      if Container.Length = 0 then
         return False;
      else
         b := Container.Data (Container.Head);
         Container.Length := Container.Length - 1;
         if Container.Head = Buffer_Size - 1 then
            Container.Head := 0;
         else
            Container.Head := Container.Head + 1;
         end if;
         return True;
      end if;
   end Dequeue_Head;

end Buffer;
