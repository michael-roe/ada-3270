with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;
with Views;
with Lines;

package Input_Stream.Tests is

   type Test_View is new Views.View with record
      Field_Count : Natural := 0;
      Last_X      : Natural := 0;
      Last_Y      : Natural := 0;
      Last_Field : Lines.Bounded_Wide_String;
   end record;

   procedure To_Physical (
      V : Test_View;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure From_Physical (
      V : in out Test_View;
      Bytes_In : Byte_Vectors.Vector);

   procedure Update_Field (
      V : in out Test_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String);

   type Input_Stream_Test is new Test_Cases.Test_Case with null record;

   procedure Test_Buffer_Address (T : in out Test_Cases.Test_Case'Class);

   procedure Test_Duplicate (T : in out Test_Cases.Test_Case'Class);

   procedure Test_Field_Mark (T : in out Test_Cases.Test_Case'Class);

   procedure Test_Overflow (T : in out Test_Cases.Test_Case'Class);

   procedure Register_Tests (T : in out Input_Stream_Test);

   function Name (T : Input_Stream_Test) return Message_String;

end Input_Stream.Tests;
