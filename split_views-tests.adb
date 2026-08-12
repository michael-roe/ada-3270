with AUnit.Assertions; use AUnit.Assertions;
with Ada.Containers; use type Ada.Containers.Count_Type;
with Ada.Wide_Text_IO;
with Ada.Strings.Unbounded;
with Ada.Characters.Conversions;
with Ada.Characters.Latin_1;
with Ada.Strings.UTF_Encoding.Wide_Strings;
with Ada.Strings.UTF_Encoding.Strings;
with Ada.Text_IO;
with Lines;
with Byte_Vectors;
with Line_Vectors;
with IBM_3270;
with IBM_3270_Orders;
with IBM_3270.Output_Stream;
with Buffer; use type Buffer.Byte;
with Code_Page_500;
with Code_Page_875;
with Outputable_Views;
with View_Text_IO;
with Block_Elements;
with Punctuation;

package body Split_Views.Tests is

   procedure Update_Field (X : Natural; Y : Natural);

   P500 : aliased Code_Page_500.Page_500;

   P875 : aliased Code_Page_875.Page_875;

   Field_Count : Natural;

   Cursor_X : Natural;

   Cursor_Y : Natural;

   Cursor_X_2 : Natural;

   Cursor_Y_2 : Natural;

   procedure Update_Field (X : Natural; Y : Natural) is
   begin

      if Field_Count = 0 then
         Cursor_X := X;
         Cursor_Y := Y;
      elsif Field_Count = 1 then
         Cursor_X_2 := X;
         Cursor_Y_2 := Y;
      end if;

      Field_Count := Field_Count + 1;

   end Update_Field;

   procedure Parse is new IBM_3270.Output_Stream.Parse (
      Update_Field => Update_Field);

   procedure Test_Short_Read (T : in out Test_Cases.Test_Case'Class) is
      V : Split_View;
      Bytes_Out : Byte_Vectors.Vector;
      Bytes_In : Byte_Vectors.Vector;
   begin

      V.To_Physical (Bytes_Out, P500'Access);

      Bytes_In.Append (IBM_3270.AID_PA1);

      V.From_Physical (Bytes_In, P500'Access);

      Assert (V.Get_AID = IBM_3270.AID_PA1, "AID should be PA1");

   end Test_Short_Read;

   procedure Test_Enter (T : in out Test_Cases.Test_Case'Class) is
      V : Split_View;
      Bytes_Out : Byte_Vectors.Vector;
      Bytes_In : Byte_Vectors.Vector;
      L : Lines.Bounded_Wide_String;
   begin

      V.To_Physical (Bytes_Out, P500'Access);

      Field_Count := 0;
      Parse (Bytes_Out);

      Bytes_In.Append (IBM_3270.AID_Enter);
      IBM_3270_Orders.Append_Buffer_Address (Bytes_In, 0, 0);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In,
         Cursor_X + 1,
         Cursor_Y);
      P500.Append (Bytes_In, "H");
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In,
         Cursor_X_2 + 1,
         Cursor_Y_2);
      P500.Append (Bytes_In, "Hello World!");

      V.From_Physical (Bytes_In, P500'Access);

      Assert (V.Get_Option = 3, "Get_Option should return 3");
      Lines.Set_Bounded_Wide_String (L, "Hello World!");
      Assert (Lines.To_Wide_String (V.Edit (0)) = "Hello World!",
         "Edit window should be Hello World!");

   end Test_Enter;

   procedure Test_Enter_Greek (T : in out Test_Cases.Test_Case'Class) is
      V : Split_View;
      Bytes_Out : Byte_Vectors.Vector;
      Bytes_In : Byte_Vectors.Vector;
      L : Lines.Bounded_Wide_String;
   begin

      V.To_Physical (Bytes_Out, P875'Access);

      Field_Count := 0;
      Parse (Bytes_Out);

      Bytes_In.Append (IBM_3270.AID_Enter);
      IBM_3270_Orders.Append_Buffer_Address (Bytes_In, 0, 0);
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In,
         Cursor_X + 1,
         Cursor_Y);
      P875.Append (Bytes_In, "H");
      IBM_3270_Orders.Set_Buffer_Address (Bytes_In,
         Cursor_X_2 + 1,
         Cursor_Y_2);

      --
      --  Unlike Code Page 500, Code Page 875 has a mapping for
      --  directional single quotation marks.
      --

      P875.Append (Bytes_In, "" &
         Punctuation.Left_Single_Quotation_Mark &
         Punctuation.Right_Single_Quotation_Mark);

      V.From_Physical (Bytes_In, P875'Access);

      Assert (V.Get_Option = 3, "Get_Option should return 3");

      Assert (Lines.To_Wide_String (V.Edit (0)) = "" &
         Punctuation.Left_Single_Quotation_Mark &
         Punctuation.Right_Single_Quotation_Mark,
         "Edit window should be open and close quotes");

   end Test_Enter_Greek;

   ASV : aliased Split_View;

   procedure Test_Put (T : in out Test_Cases.Test_Case'Class) is
      OA : Outputable_Views.Outputable_Access;
      US : Ada.Strings.Unbounded.Unbounded_String;
      W : Wide_Character;
      Four_Byte_Example : Ada.Strings.UTF_Encoding.UTF_String := "(" &
         Character'Val (16#F0#) &
         Character'Val (16#9F#) &
         Character'Val (16#90#) &
         Character'Val (16#81#) &
         ')';
   begin

      OA := ASV'Access;

      US := Ada.Strings.Unbounded.To_Unbounded_String (
         Ada.Strings.UTF_Encoding.Strings.Encode ("Test"));
      View_Text_IO.Put (OA, US);

      Assert (Lines.Length (ASV.History.Element (0)) = 4,
         "History first line length should be 4");

      Assert (Lines.To_Wide_String (ASV.History.Element (0)) = "Test",
         "History should contain Test");

      US := Ada.Strings.Unbounded.To_Unbounded_String (
         Ada.Strings.UTF_Encoding.Strings.Encode ("" &
            Ada.Characters.Latin_1.Multiplication_Sign));
      View_Text_IO.Put (OA, US);

      Assert (Lines.Length (ASV.History.Element (0)) = 5,
         "History first line length should be 5");

      W := Ada.Characters.Conversions.To_Wide_Character (
         Ada.Characters.Latin_1.Multiplication_Sign);

      Assert (Lines.To_Wide_String (ASV.History.Element (0)) = "Test" & W,
         "Should be Multiplication_Sign in History");

      W := Block_Elements.Full;

      US := Ada.Strings.Unbounded.To_Unbounded_String (
         Ada.Strings.UTF_Encoding.Wide_Strings.Encode ("" & W));
      View_Text_IO.Put (OA, US);

      Assert (Lines.Length (ASV.History.Element (0)) = 6,
         "History first line length should be 6");

      Assert (Lines.Element (ASV.History.Element (0), 6) = W,
         "History should contain block element");

      View_Text_IO.Put (OA,
         Ada.Strings.Unbounded.To_Unbounded_String (Four_Byte_Example));

      Assert (Lines.Element (ASV.History.Element (0), 7) = '(',
         "History should contain open parethesis");

      Assert (Lines.Element (ASV.History.Element (0), 8) = '?',
         "History should contain question mark");

      Assert (Lines.Element (ASV.History.Element (0), 9) = ')',
         "History should contain close parethesis");

      US := Ada.Strings.Unbounded.To_Unbounded_String (
         Ada.Strings.UTF_Encoding.Strings.Encode ("" &
            Character'Val (10) & "*"));
      View_Text_IO.Put (OA, US);

      Assert (Lines.Element (ASV.History.Element (1), 1) = '*',
         "History should contain asterisk");

   end Test_Put;

   procedure Test_Put_Invalid (T : in out Test_Cases.Test_Case'Class) is
      OA : Outputable_Views.Outputable_Access;
      US : Ada.Strings.Unbounded.Unbounded_String;
      W : Wide_Character;
      Bad_Encoding_2 : Ada.Strings.UTF_Encoding.UTF_String := "" &
         Character'Val (16#C4#) &
         Character'Val (0);
      Bad_Encoding_4 : Ada.Strings.UTF_Encoding.UTF_String := "" &
         Character'Val (16#F0#) &
         Character'Val (0) &
         Character'Val (0) &
         Character'Val (0);
   begin

      OA := ASV'Access;

      View_Text_IO.Put (OA,
         Ada.Strings.Unbounded.To_Unbounded_String (Bad_Encoding_2));

      View_Text_IO.Put (OA,
         Ada.Strings.Unbounded.To_Unbounded_String (Bad_Encoding_4));

   end Test_Put_Invalid;

   procedure Register_Tests (T : in out Split_View_Test) is
      use AUnit.Test_Cases.Registration;
   begin

      Register_Routine (T, Test_Short_Read'Access,
         "Test_Short_Read");

      Register_Routine (T, Test_Enter'Access,
         "Test_Enter");

      Register_Routine (T, Test_Enter_Greek'Access,
         "Test_Enter_Greek");

      Register_Routine (T, Test_Put'Access,
         "Test_Put");

      Register_Routine (T, Test_Put_Invalid'Access,
         "Test_Put_Invalid");

   end Register_Tests;

   function Name (T : Split_View_Test) return Message_String is
   begin
      return Format ("Split_Views_Tests");
   end Name;

end Split_Views.Tests;
