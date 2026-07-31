with Buffer.Tests;
with Buffer_Queues_Tests;
with Telnet.Options.Tests;
with Telnet.Environ.Tests;
with Code_Page_500.Tests;
with Code_Page_310.Tests;
with Code_Page_870.Tests;
with Line_Vectors_Tests;
with IBM_3270_Orders.Tests;
with Input_Stream.Tests;
with Split_Views.Tests;
with Text_Views.Tests;
with Login_Views.Tests;
with Checkbox_Views.Tests;
with Menu_Views.Tests;
with Numbered_Menu_Views.Tests;

package body My_Test_Suite is

   use AUnit.Test_Suites;

   --  Statically allocate test suite:
   Result : aliased Test_Suite;

   --  Statically allocate test cases:
   Test_1  : aliased Buffer.Tests.Buffer_Test;
   Test_2  : aliased Buffer_Queues_Tests.Buffer_Queues_Test;
   Test_3  : aliased Telnet.Options.Tests.Telnet_Options_Test;
   Test_4  : aliased Code_Page_500.Tests.Code_Page_Test;
   Test_5  : aliased Code_Page_310.Tests.Code_Page_Test;
   Test_6  : aliased Code_Page_870.Tests.Code_Page_Test;
   Test_7  : aliased Line_Vectors_Tests.Line_Vectors_Test;
   Test_8  : aliased IBM_3270_Orders.Tests.IBM_3270_Orders_Test;
   Test_9  : aliased Input_Stream.Tests.Input_Stream_Test;
   Test_10 : aliased Split_Views.Tests.Split_View_Test;
   Test_11 : aliased Text_Views.Tests.Text_View_Test;
   Test_12 : aliased Login_Views.Tests.Login_View_Test;
   Test_13 : aliased Checkbox_Views.Tests.Checkbox_View_Test;
   Test_14 : aliased Menu_Views.Tests.Menu_View_Test;
   Test_15 : aliased Numbered_Menu_Views.Tests.Numbered_Menu_View_Test;
   Test_16 : aliased Telnet.Environ.Tests.Environ_Test;

   function Suite return Access_Test_Suite is
   begin

      Add_Test (Result'Access, Test_1'Access);
      Add_Test (Result'Access, Test_2'Access);
      Add_Test (Result'Access, Test_3'Access);
      Add_Test (Result'Access, Test_4'Access);
      Add_Test (Result'Access, Test_5'Access);
      Add_Test (Result'Access, Test_6'Access);
      Add_Test (Result'Access, Test_7'Access);
      Add_Test (Result'Access, Test_8'Access);
      Add_Test (Result'Access, Test_9'Access);
      Add_Test (Result'Access, Test_10'Access);
      Add_Test (Result'Access, Test_11'Access);
      Add_Test (Result'Access, Test_12'Access);
      Add_Test (Result'Access, Test_13'Access);
      Add_Test (Result'Access, Test_14'Access);
      Add_Test (Result'Access, Test_15'Access);
      Add_Test (Result'Access, Test_16'Access);

      return Result'Access;

   end Suite;

end My_Test_Suite;
