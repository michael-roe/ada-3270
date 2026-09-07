package body IBM_3270.Structured_Fields is

   procedure Read_Partition_Query (Bytes_Out : in out Byte_Vectors.Vector) is
   begin

      Bytes_Out.Append (0);      --  MSB of length
      Bytes_Out.Append (5);      --  LSB of length
      Bytes_Out.Append (16#01#); --  Read Partition
      Bytes_Out.Append (16#FF#);
      Bytes_Out.Append (16#02#); --  Query

   end Read_Partition_Query;

end IBM_3270.Structured_Fields;
