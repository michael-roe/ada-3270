package body Buffer is

  procedure Clear(buff: in out T) is
  begin
    buff.length := 0;
  end;

  function Insert(buff: in out T; b: Byte) return Boolean is
  begin
    if buff.length = Buffer_Size then
      return False;
    else
      buff.data(Buffer_Index(buff.length)) := b;
      buff.length := buff.length + 1;
      return True;
    end if;
  end;

end Buffer;
