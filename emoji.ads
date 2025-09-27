package Emoji is

   --  These values are defined by:
   --  Unicode Consortium. The Unicode Standard, version 17.0

   Variation_Selector_Text : constant Wide_Character :=
      Wide_Character'Val (16#FE0E#);

   Variation_Selector_Emoji : constant Wide_Character :=
      Wide_Character'Val (16#FE0F#);

   White_Heavy_Check_Mark : constant Wide_Character :=
      Wide_Character'Val (16#2705#);

   Cross_Mark : constant Wide_Character :=
      Wide_Character'Val (16#274C#);

end Emoji;
