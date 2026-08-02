with Byte_Vectors;
with Buffer_Queues;
with Telnet.Event_Handlers;
with Code_Pages;

package Test_Break_Handlers is

   type Test_Break_Handler is new Telnet.Event_Handlers.Handler with record
      Counter : Natural := 0;
      Break_Received : Boolean := False;
   end record;

   --
   --  Test_Break_Handler is a test of Telnet BREAK.
   --
   --  The first panel it sends has Go Ahead set and
   --  asks the user to press ENTER. The second panel
   --  has Go Ahead clear and asks the user to press
   --  ATTN. As Go Ahead is not set, ATTN is the only
   --  key the terminal will allow to be pressed.
   --

   procedure To_Physical (
      V         : in out Test_Break_Handler;
      Bytes_Out : in out Byte_Vectors.Vector;
      P        : Code_Pages.Code_Page_Access;
      Go_Ahead  : in out Boolean);

   procedure From_Physical (
      V        : in out Test_Break_Handler;
      Bytes_In : Byte_Vectors.Vector;
      P        : Code_Pages.Code_Page_Access);

   procedure Break (V : in out Test_Break_Handler);

   procedure Initialize (V : in out Test_Break_Handler);

   procedure Set_RX_TX (
      V  : in out Test_Break_Handler;
      RX : access Buffer_Queues.Queue;
      TX : access Buffer_Queues.Queue);

end Test_Break_Handlers;
