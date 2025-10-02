with Buffer; use type Buffer.Byte;
with Telnet.Options;

package body Telnet.Negotiation is

   type Progress is (No, Want_No, Want_Yes, Yes);

   type Option_Id is (
      Unknown,
      Transmit_Binary,
      Supress_Go_Ahead,
      Terminal_Type,
      EOR,
      New_Environ);

   type State is record
      Us        : Progress := No;
      Us_Q      : Boolean := False;
      Them      : Progress := No;
      Them_Q    : Boolean := False;
      Supported : Boolean := True;
   end record;

   States : aliased array (Option_Id) of State;

   function Find (Option : Buffer.Byte) return Option_Id;

   function Find (Option : Buffer.Byte) return Option_Id is
   begin
      case Option is
         when Telnet.Options.Transmit_Binary =>
            return Transmit_Binary;
         when Telnet.Options.Supress_Go_Ahead =>
            return Supress_Go_Ahead;
         when Telnet.Options.Terminal_Type =>
            return Terminal_Type;
         when Telnet.Options.End_Of_Record =>
            return EOR;
         when Telnet.Options.New_Environ =>
            return New_Environ;
         when others =>
            return Unknown;
      end case;
   end Find;

   procedure Will (Option : Buffer.Byte; Reply : out Do_Dont) is
      Index : Option_Id;
   begin
      Index := Find (Option);
      case States (Index).Them is
         when No =>
            if States (Index).Supported then
               States (Index).Them := Yes;
               Reply := Send_Do_It;
            else
               Reply := Send_Dont;
            end if;
         when Yes =>
            Reply := Send_Nothing;
         when Want_No =>
            --
            --  This is an error condition thhat shouldn't happen
            --
            if States (Index).Them_Q then
               States (Index).Them := Yes;
               States (Index).Them_Q := False;
               Reply := Send_Nothing;
            else
               States (Index).Them := No;
            end if;
         when Want_Yes =>
            if States (Index).Them_Q then
               States (Index).Them := Want_No;
               States (Index).Them_Q := False;
               Reply := Send_Dont;
            else
               States (Index).Them := Yes;
               Reply := Send_Nothing;
            end if;
      end case;
   end Will;

   procedure Wont (Option : Buffer.Byte; Reply : out Do_Dont) is
      Index : Option_Id;
   begin
      Index := Find (Option);
      case States (Index).Them is
         when No =>
            Reply := Send_Nothing;
         when Yes =>
            States (Index).Them := No;
            Reply := Send_Dont;
         when others =>
            null;
      end case;
   end Wont;

   procedure Request_Enable (Option : Buffer.Byte; Reply : out Do_Dont) is
      Index : Option_Id;
   begin
      Index := Find (Option);
      case States (Index).Them is
         when No =>
            States (Index).Them := Want_Yes;
            Reply := Send_Do_It;
         when Yes =>
            --
            --  Error condition: already enabled
            --
            Reply := Send_Nothing;
         when Want_No =>
            if States (Index).Them_Q then
               Reply := Send_Nothing;
            else
               States (Index).Them_Q := True;
               Reply := Send_Nothing;
            end if;
         when Want_Yes =>
            if States (Index).Them_Q then
               States (Index).Them_Q := False;
               Reply := Send_Nothing;
            else
               Reply := Send_Nothing;
            end if;
      end case;
   end Request_Enable;

   procedure Do_It (Option : Buffer.Byte; Reply : out Will_Wont) is
   begin
      null;
   end Do_It;

   procedure Dont (Option : Buffer.Byte; Reply : out Will_Wont) is
   begin
      null;
   end Dont;

begin

   States (Unknown).Supported := False;

end Telnet.Negotiation;
