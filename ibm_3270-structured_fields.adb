package body IBM_3270.Structured_Fields is

   procedure Read_Partition_Query (Bytes_Out : in out Byte_Vectors.Vector) is
   begin

      Bytes_Out.Append (0);      --  MSB of length
      Bytes_Out.Append (5);      --  LSB of length
      Bytes_Out.Append (16#01#); --  Read Partition
      Bytes_Out.Append (16#FF#);
      Bytes_Out.Append (16#02#); --  Query

   end Read_Partition_Query;

   procedure Set_Reply_Mode (
      Bytes_Out : in out Byte_Vectors.Vector;
      Reply_Mode : IBM_3270_Orders.Reply_Mode;
      Enable_Highlight : Boolean := False;
      Enable_Foreground_Color : Boolean := False;
      Enable_Background_Color : Boolean := False;
      Enable_Symbols : Boolean := False) is
      Length : Buffer.Byte;
   begin

      Length := 5;

      if Enable_Highlight then
         Length := Length + 1;
      end if;

      if Enable_Foreground_Color then
         Length := Length + 1;
      end if;

      if Enable_Background_Color then
         Length := Length + 1;
      end if;

      if Enable_Symbols then
         Length := Length + 1;
      end if;

      Bytes_Out.Append (0);
      Bytes_Out.Append (Length);
      Bytes_Out.Append (16#09#); --  Set Reply Mode
      Bytes_Out.Append (0);
      Bytes_Out.Append (IBM_3270_Orders.Reply_Mode'Pos (Reply_Mode));

      if Enable_Highlight then
         Bytes_Out.Append (IBM_3270.Attribute_Highlight);
      end if;

      if Enable_Foreground_Color then
         Bytes_Out.Append (IBM_3270.Attribute_Foreground_Color);
      end if;

      if Enable_Background_Color then
         Bytes_Out.Append (IBM_3270.Attribute_Background_Color);
      end if;

      if Enable_Symbols then
         Bytes_Out.Append (IBM_3270.Attribute_Symbols);
      end if;

   end Set_Reply_Mode;

end IBM_3270.Structured_Fields;
