package body Buffer is

   function Is_Empty (buff : T) return Boolean is
   begin
      return buff.length = 0;
   end Is_Empty;

   function Is_Full (buff : T) return Boolean is
   begin
      return buff.length = Buffer_Size;
   end Is_Full;

   procedure Clear (buff : in out T) is
   begin
      buff.length := 0;
      buff.head := 0;
      buff.tail := 0;
   end Clear;

   function Enqueue_Tail (buff : in out T; b : Byte) return Boolean is
   begin
      if buff.length = Buffer_Size then
         return False;
      else
         buff.data (buff.tail) := b;
         buff.length := buff.length + 1;
         if buff.tail = Buffer_Size - 1 then
            buff.tail := 0;
         else
            buff.tail := buff.tail + 1;
         end if;
         return True;
      end if;
   end Enqueue_Tail;

   function Dequeue_Head (buff : in out T; b : in out Byte) return Boolean is
   begin
      if buff.length = 0 then
         return False;
      else
         b := buff.data (buff.head);
         buff.length := buff.length - 1;
         if buff.head = Buffer_Size - 1 then
            buff.head := 0;
         else
            buff.head := buff.head + 1;
         end if;
         return True;
      end if;
   end Dequeue_Head;

end Buffer;
