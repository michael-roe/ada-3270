with Buffer_Tests;
with Buffer_Queues_Tests;
with Telnet_Options_Tests;

package body Buffer_Suite is

   use AUnit.Test_Suites;

   --  Statically allocate test suite:
   Result : aliased Test_Suite;

   --  Statically allocate test cases:
   Test_1 : aliased Buffer_Tests.Buffer_Test;
   Test_2 : aliased Buffer_Queues_Tests.Buffer_Queues_Test;
   Test_3 : aliased Telnet_Options_Tests.Telnet_Options_Test;

   function Suite return Access_Test_Suite is
   begin
      Add_Test (Result'Access, Test_1'Access);
      Add_Test (Result'Access, Test_2'Access);
      Add_Test (Result'Access, Test_3'Access);
      return Result'Access;
   end Suite;

end Buffer_Suite;
