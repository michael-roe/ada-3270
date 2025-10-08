with Ada.Containers; use Ada.Containers;
with Interfaces;

package Buffer is

   subtype Byte is Interfaces.Unsigned_8;

   type Byte_Array is array
      (Ada.Containers.Count_Type range <>) of Byte;

   Buffer_Size : constant := 4096;

   type T is private;

   --
   --  The type Buffer.T represents a buffer in a communications protocol
   --

   function Is_Empty (Container : T) return Boolean;

   --
   --  Is_Empty returns true if there is no data left to read in the buffer
   --

   function Is_Full (Container : T) return Boolean;

   --
   --  Is_Full returns true if there no space to write data into the buffer
   --

   function Current_Use (Container : T) return Count_Type;

   --
   --  Current_Use returns the number of elements in the buffer
   --

   function Peak_Use (Container : T) return Count_Type;

   --
   --  Peak_Use returns the maximum number of elements since the last Clear
   --

   procedure Clear (Container : in out T);

   --
   --  Clear sets the contents of the buffer to empty
   --
   --  Formal properties:
   --
   --  (a) After Clear, the buffer is empty
   --  (b) After Clear, the buffer is not full (Buffer_Size is not zero)

   function Enqueue_Tail (Container : in out T; b : Byte) return Boolean;

   --
   --  Enqueue_Tail appends b to the end of buffer if there is space for it.
   --  It returns True is b was added to the buffer, False otherwise
   --
   --  Formal properties:
   --
   --  (a) Enqueue_Tail will never raise an exception
   --  (b) If Enqueue_Tail returns True, b was added to the buffer
   --  (c) If Enqueue_Tail returns False, the buffer is unchanged
   --  (d) If the buffer is not full, Enqueue_Tail will return True

   function Dequeue_Head (Container : in out T; b : in out Byte)
      return Boolean;

   --
   --  Dequeue_Head takes a byte from the head of the queue
   --  It returns True is there was a byte to take, False otherwise.
   --
   --  Formal properties:
   --
   --  (a) Dequeue_Head will never raise an exception
   --  (b) If Dequeue_Head returns True, b is the byte from the head of
   --      the buffer and it has been removed from the buffer
   --  (c) If Dequeue_Head returns True, the buffer is unchanged
   --  (d) If the buffer is not empty, Dequeue_Head will return True

private

   subtype Buffer_Index is Ada.Containers.Count_Type
      range 0 ..  Buffer_Size - 1;

   subtype Buffer_Length is Ada.Containers.Count_Type
      range 0 .. Buffer_Size;

   type InternalBuffer is array (Buffer_Index) of Byte;

   type T is record
      length : Buffer_Length := 0;
      head   : Buffer_Index;
      tail   : Buffer_Index;
      peak   : Buffer_Length;
      data   : InternalBuffer;
   end record;

end Buffer;
