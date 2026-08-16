with Ada.Strings;
with Ada.Containers;
use type Ada.Containers.Count_Type;
with Ada.Text_IO;
with Telnet.Options;
with Telnet_Strings;

package body Telnet.Environ is

   type State is (State_Start, State_Name, State_Value);

   type Byte_Array is array (1 .. 10) of Buffer.Byte;

   procedure Parse (V : Byte_Vectors.Vector) is
      B : Buffer.Byte;
      State_Escape : Boolean;
      State_User_Var : Boolean;
      State_NV : State;
      Name_String : Telnet_Strings.Bounded_String;
      Value_String : Telnet_Strings.Bounded_String;
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

      State_User_Var := False;

      for J in V.First_Index + 2 .. V.Last_Index loop
         B := V.Element (J);
         if B = Var_Tag and not State_Escape then
            if State_NV = State_Value then
               Callback (Name_String, Value_String, State_User_Var);
            elsif State_NV = State_Name then
               Callback_Undef (Name_String, State_User_Var);
            end if;
            State_NV := State_Name;
            State_User_Var := False;
            Telnet_Strings.Set_Bounded_String (Name_String, "");
         elsif B = User_Var_Tag and not State_Escape then
            if State_NV = State_Value then
               Callback (Name_String, Value_String, State_User_Var);
            elsif State_NV = State_Name then
               Callback_Undef (Name_String, State_User_Var);
            end if;
            State_NV := State_Name;
            State_User_Var := True;
            Telnet_Strings.Set_Bounded_String (Name_String, "");
         elsif B = Value_Tag and not State_Escape then
            State_NV := State_Value;
            Telnet_Strings.Set_Bounded_String (Value_String, "");
         elsif B = Esc_Tag and not State_Escape then
            State_Escape := True;
         else
            if State_NV = State_Name then
               Telnet_Strings.Append (Name_String,
                  Character'Val (B),
                  Ada.Strings.Right);
            elsif State_NV = State_Value then
               Telnet_Strings.Append (Value_String,
                  Character'Val (B),
                  Ada.Strings.Right);
            end if;
            State_Escape := False;
         end if;
      end loop;

      if State_NV = State_Value then
         Callback (Name_String, Value_String, State_User_Var);
      elsif State_NV = State_Name then
         Callback_Undef (Name_String, State_User_Var);
      end if;

   end Parse;

end Telnet.Environ;
