with Ada.Text_IO;
with Buffer;
use type Buffer.Byte;

package Byte_Text_IO is new Ada.Text_IO.Modular_IO (Buffer.Byte);
