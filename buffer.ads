with Interfaces;

package Buffer is

  subtype Byte is Interfaces.Unsigned_8;

  type Bytes is array(Integer range <>) of Byte;

  type T is private;

  --
  -- The type Buffer.T represents a buffer in a communications protocol
  --

  procedure Clear(buff: in out T);

  --
  -- Clear sets the contents of the buffer to empty
  --
  -- Formal properties:
  --
  -- (a) After Clear, the buffer is empty
  --

  function Insert(buff: in out T; b : Byte) return Boolean;

  --
  -- Insert adds b to the buffer if there is space for it
  -- It returns True is b was added to the buffer, false otherwise
  --
  -- Formal properties:
  --
  -- (a) Insert will never raise an exception
  -- (b) If Insert returns True, b was added to the buffer
  -- (c) If Insert returns False, the buffer is unchanged
  -- (d) Insert after Clear will return True
  --     (i.e. there is space for at least one byte in the buffer)

private

  Buffer_Size : constant := 4096;

  type Buffer_Index is range 0 .. Buffer_Size - 1;

  type Buffer_Length is range 0 .. Buffer_Size;

  type InternalBuffer is array (Buffer_Index) of Byte;

  type T is record
    data: InternalBuffer;
    length: Buffer_Length;
  end record;

end Buffer;
