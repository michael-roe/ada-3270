with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package Buffer_Queues_Tests is

   type Buffer_Queues_Test is new Test_Cases.Test_Case with null record;

   procedure Register_Tests (T : in out Buffer_Queues_Test);

   function Name (T : Buffer_Queues_Test) return Message_String;

   procedure Test_Clear (T : in out Test_Cases.Test_Case'Class);

   procedure Test_Enqueue_Dequeue (T : in out Test_Cases.Test_Case'Class);

   procedure Test_TX_RX (T : in out Test_Cases.Test_Case'Class);

end Buffer_Queues_Tests;
