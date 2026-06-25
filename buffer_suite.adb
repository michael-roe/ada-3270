with Buffer_Tests;
with Buffer_Queues_Tests;
with Telnet_Options_Tests;
with Code_Page_500.Tests;
with Code_Page_310.Tests;

package body Buffer_Suite is

   use AUnit.Test_Suites;

   --  Statically allocate test suite:
   Result : aliased Test_Suite;

   --  Statically allocate test cases:
   Test_1 : aliased Buffer_Tests.Buffer_Test;
   Test_2 : aliased Buffer_Queues_Tests.Buffer_Queues_Test;
   Test_3 : aliased Telnet_Options_Tests.Telnet_Options_Test;
   Test_4 : aliased Code_Page_500.Tests.Code_Page_Test;
   Test_5 : aliased Code_Page_310.Tests.Code_Page_Test;

   function Suite return Access_Test_Suite is
   begin
      Add_Test (Result'Access, Test_1'Access);
      Add_Test (Result'Access, Test_2'Access);
      Add_Test (Result'Access, Test_3'Access);
      Add_Test (Result'Access, Test_4'Access);
      Add_Test (Result'Access, Test_5'Access);
      return Result'Access;
   end Suite;

end Buffer_Suite;
