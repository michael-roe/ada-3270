with Interfaces;

package Buffer is

  subtype Byte is Interfaces.Unsigned_8;

  type Bytes is array(Integer range <>) of Byte;

  type T is private;

  --
  -- The type Buffer.T represents a buffer in a communications protocol
  --

  function Is_Empty(buff: in T) return Boolean;

  --
  -- Is_Empty returns true is there is no data left to read in the buffer
  --

  function Is_Full(buff: in T) return Boolean;

  --
  -- Is_Full returns true is there no space to write data into the buffer
  --

  procedure Clear(buff: in out T);

  --
  -- Clear sets the contents of the buffer to empty
  --
  -- Formal properties:
  --
  -- (a) After Clear, the buffer is empty
  -- (b) After Clear, the buffer is not full (Buffer_Size is not zero)

  function Enqueue_Tail(buff: in out T; b : Byte) return Boolean;

  --
  -- Enqueue_Tail appends b to the end of buffer if there is space for it.
  -- It returns True is b was added to the buffer, False otherwise
  --
  -- Formal properties:
  --
  -- (a) Enqueue_Tail will never raise an exception
  -- (b) If Enqueue_Tail returns True, b was added to the buffer
  -- (c) If Enqueue_Tail returns False, the buffer is unchanged
  -- (d) If the buffer is not full, Enqueue_Tail will return True

  function Dequeue_Head(buff: in out T; b: in out Byte) return Boolean;

  --
  -- Dequeue_Head takes a byte from the head of the queue
  -- It returns True is there was a byte to take, False otherwise.
  --
  -- Formal properties:
  --
  -- (a) Dequeue_Head will never raise an exception
  -- (b) If Dequeue_Head returns True, b is the byte from the head of
  --     the buffer and it has been removed from the buffer
  -- (c) If Dequeue_Head returns True, the buffer is unchanged
  -- (d) If the buffer is not empty, Dequeue_Head will return True

private

  Buffer_Size : constant := 4096;

  type Buffer_Index is range 0 .. Buffer_Size - 1;

  type Buffer_Length is range 0 .. Buffer_Size;

  type InternalBuffer is array (Buffer_Index) of Byte;

  type T is record
    length: Buffer_Length;
    head: Buffer_Index;
    tail: Buffer_Index;
    data: InternalBuffer;
  end record;

end Buffer;
