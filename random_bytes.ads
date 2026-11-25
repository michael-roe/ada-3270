with Buffer;
with Ada.Numerics.Discrete_Random;

package Random_Bytes is
   new Ada.Numerics.Discrete_Random (Result_Subtype => Buffer.Byte);
