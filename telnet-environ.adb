with Ada.Containers;
use type Ada.Containers.Count_Type;
with Ada.Text_IO;
with Telnet.Options;

package body Telnet.Environ is

   type State is (State_Start, State_Name, State_Value);

   type Byte_Array is array (1 .. 10) of Buffer.Byte;

   procedure Debug (N : Byte_Array; V : Byte_Array) is
   begin

      Ada.Text_IO.Put ("NAME = ");

      for J in N'First .. N'Last loop
         Ada.Text_IO.Put (Character'Val (N (J)));
      end loop;

      Ada.Text_IO.New_Line;

      Ada.Text_IO.Put ("VALUE = ");

      for J in V'First .. N'Last loop
         Ada.Text_IO.Put (Character'Val (V (J)));
      end loop;

      Ada.Text_IO.New_Line;

   end Debug;

   procedure Parse (V : Byte_Vectors.Vector) is
      B : Buffer.Byte;
      State_Escape : Boolean;
      State_User_Var : Boolean;
      State_NV : State;
      Variable_Name : Byte_Array;
      Variable_Value : Byte_Array;
      Name_Bytes : Integer;
      Value_Bytes : Integer;
   begin

      if V.Length < 2 then
         return;
      end if;

      if V.Element (V.First_Index) /= Telnet.Options.New_Environ then
         return;
      end if;

      if V.Element (V.First_Index + 1) /= Is_Cmd then
         return;
      end if;

      State_NV := State_Start;

      State_Escape := False;

      for J in V.First_Index + 2 .. V.Last_Index loop
         B := V.Element (J);
         if B = Var_Tag and not State_Escape then
            if State_NV = State_Value then
               Debug (Variable_Name, Variable_Value);
            end if;
            Ada.Text_IO.Put_Line ("[VAR]");
            State_NV := State_Name; 
            State_User_Var := False;
            Name_Bytes := 0;
            for J in Variable_Name'Range loop
               Variable_Name (J) := Character'Pos ('*');
            end loop;
         elsif B = User_Var_Tag and not State_Escape then
            if State_NV = State_Value then
               Debug (Variable_Name, Variable_Value);
            end if;
            Ada.Text_IO.Put_Line ("[USERVAR]");
            State_NV := State_Name;
            State_User_Var := True;
            Name_Bytes := 0;
            for J in Variable_Name'Range loop
               Variable_Name (J) := Character'Pos ('*');
            end loop;
         elsif B = Value_Tag and not State_Escape then
            Ada.Text_IO.Put_Line ("[VALUE]");
            State_NV := State_Value;
            Value_Bytes := 0;
            for J in Variable_Value'Range loop
               Variable_Value (J) := Character'Pos ('*');
            end loop;
         elsif B = Esc_Tag and not State_Escape then
            State_Escape := True;
         else
            if State_NV = State_Name then
               if Name_Bytes < Variable_Name'Length then
                 Name_Bytes := Name_Bytes + 1;
                 Variable_Name (Name_Bytes) := B;
               end if;
            elsif State_NV = State_Value then
               if Value_Bytes < Variable_Value'Length then
                  Value_Bytes := Value_Bytes + 1;
                  Variable_Value (Value_Bytes) := B;
               end if;
            end if;
            State_Escape := False;
         end if;
      end loop;

      Debug (Variable_Name, Variable_Value);

   end Parse;

end Telnet.Environ;
