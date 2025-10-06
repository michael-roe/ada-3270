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

   type Wanted_Option is record
      Direction : Request_Offer;
      Option : Buffer.Byte;
   end record;

   type Wanted_Index_Type is new Integer range 1 .. 9;

   Wanted_Options : array (Wanted_Index_Type) of Wanted_Option :=
   (
      (Request, Telnet.Options.Terminal_Type),
      (Request, Telnet.Options.New_Environ),
      (Request, Telnet.Options.Transmit_Binary),
      (Offer,   Telnet.Options.Transmit_Binary),
      (Request, Telnet.Options.End_Of_Record),
      (Offer,   Telnet.Options.End_Of_Record),
      (Request, Telnet.Options.Supress_Go_Ahead),
      (Offer,   Telnet.Options.Supress_Go_Ahead),
      (Done, 0)
   );
 
   Wanted_Index : Wanted_Index_Type := 1;

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

   function Is_Enabled (Option : Buffer.Byte) return Boolean is
      Index : Option_Id;
   begin
      Index := Find (Option);
      return States (Index).Us = Yes;
   end Is_Enabled;

   function Is_Peer_Enabled (Option : Buffer.Byte) return Boolean is
      Index : Option_Id;
   begin
      Index := Find (Option);
      return States (Index).Them = Yes;
   end Is_Peer_Enabled;

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
            --  This is an error condition that shouldn't happen
            --
            if States (Index).Them_Q then
               States (Index).Them := Yes;
               States (Index).Them_Q := False;
               Reply := Send_Nothing;
            else
               States (Index).Them := No;
               Reply := Send_Nothing;
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
         when Want_Yes =>
            States (Index).Them := No;
            States (Index).Them_Q := False;
            Reply := Send_Nothing;
         when Want_No =>
            if States (Index).Them_Q then
               States (Index).Them := Want_Yes;
               States (Index).Them_Q := False;
               Reply := Send_Do_It;
            else
               States (Index).Them := No;
               Reply := Send_Nothing;
            end if;
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

   procedure Request_Disable (Option : Buffer.Byte; Reply : out Do_Dont) is
      Index : Option_Id;
   begin
      Index := Find (Option);
      case States (Index).Them is
         when No =>
            --  Error condition: already disabled
            Reply := Send_Nothing;
         when Yes =>
            States (Index).Them := Want_No;
            Reply := Send_Dont;
         when Want_No =>
            if States (Index).Them_Q then
               States (Index).Them_Q := False;
               Reply := Send_Nothing;
            else
               Reply := Send_Nothing;
            end if;
         when Want_Yes =>
            if States (Index).Them_Q then
               Reply := Send_Nothing;
            else
               States (Index).Them_Q := True;
               Reply := Send_Nothing;
            end if;
      end case;
   end Request_Disable;

   procedure Do_It (Option : Buffer.Byte; Reply : out Will_Wont) is
      Index : Option_Id;
   begin
      Index := Find (Option);
      case States (Index).Us is
         when No =>
            if States (Index).Supported then
               States (Index).Us := Yes;
               Reply := Send_Will;
            else
               Reply := Send_Wont;
            end if;
         when Yes =>
            Reply := Send_Nothing;
         when Want_No =>
            --
            --  This is an error condition that shouldn't happen
            --
            if States (Index).Us_Q then
               States (Index).Us := Yes;
               States (Index).Us_Q := False;
               Reply := Send_Nothing;
            else
               States (Index).Us := No;
               Reply := Send_Nothing;
            end if;
         when Want_Yes =>
            if States (Index).Us_Q then
               States (Index).Us := Want_No;
               States (Index).Us_Q := False;
               Reply := Send_Wont;
            else
               States (Index).Us := Yes;
               Reply := Send_Nothing;
            end if;
      end case;
   end Do_It;

   procedure Dont (Option : Buffer.Byte; Reply : out Will_Wont) is
      Index : Option_Id;
   begin
      Index := Find (Option);
      case States (Index).Us is
         when No =>
            Reply := Send_Nothing;
         when Yes =>
            States (Index).Us := No;
            Reply := Send_Wont;
         when Want_Yes =>
            States (Index).Us := No;
            States (Index).Us_Q := False;
            Reply := Send_Nothing;
         when Want_No =>
            if States (Index).Us_Q then
               States (Index).Us := Want_Yes;
               States (Index).Us_Q := False;
               Reply := Send_Will;
            else
               States (Index).Us := No;
               Reply := Send_Nothing;
            end if;
      end case;
   end Dont;

   procedure Offer_Enable (Option : Buffer.Byte; Reply : out Will_Wont) is
      Index : Option_Id;
   begin
      Index := Find (Option);
      case States (Index).Us is
         when No =>
            States (Index).Us := Want_Yes;
            Reply := Send_Will;
         when Yes =>
            --
            --  Error condition: already enabled
            --
            Reply := Send_Nothing;
         when Want_No =>
            if States (Index).Us_Q then
               Reply := Send_Nothing;
            else
               States (Index).Us_Q := True;
               Reply := Send_Nothing;
            end if;
         when Want_Yes =>
            if States (Index).Us_Q then
               States (Index).Us_Q := False;
               Reply := Send_Nothing;
            else
               Reply := Send_Nothing;
            end if;
      end case;
   end Offer_Enable;

   procedure Disable (Option : Buffer.Byte; Reply : out Will_Wont) is
      Index : Option_Id;
   begin
      Index := Find (Option);
      case States (Index).Us is
         when No =>
            --  Error condition: already disabled
            Reply := Send_Nothing;
         when Yes =>
            States (Index).Us := Want_No;
            Reply := Send_Wont;
         when Want_No =>
            if States (Index).Us_Q then
               States (Index).Us_Q := False;
               Reply := Send_Nothing;
            else
               Reply := Send_Nothing;
            end if;
         when Want_Yes =>
            if States (Index).Us_Q then
               Reply := Send_Nothing;
            else
               States (Index).Us_Q := True;
               Reply := Send_Nothing;
            end if;
      end case;
   end Disable;

   procedure Next_Option
      (Direction : out Request_Offer; 
       Option    : out Buffer.Byte) is
      Found : Boolean;
   begin

      Found := False;
      while not Found loop
         case Wanted_Options (Wanted_Index).Direction is
            when Done =>
               Found := True;
            when Offer =>
               if States (Find (Wanted_Options
                  (Wanted_Index).Option)).Us /= Yes then
                  Found := True;
               end if;
            when Request =>
               if States (Find (Wanted_Options
                  (Wanted_Index).Option)).Them /= Yes then
                  Found := True;
               end if;
         end case;
         if not Found then
            Wanted_Index := Wanted_Index + 1;
         end if;
      end loop;
      
      Direction := Wanted_Options (Wanted_Index).Direction;
      Option := Wanted_Options (Wanted_Index).Option;

   end Next_Option;

begin

   States (Unknown).Supported := False;

end Telnet.Negotiation;
