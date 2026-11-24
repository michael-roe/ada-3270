with Ada.Characters.Latin_1;
with Unicode.Names.General_Punctuation;
with Buffer;
use type Buffer.Byte;
with Byte_Vectors;
with Code_Page_310;

package body Code_Page_037 is

   Table : constant  array (Buffer.Byte) of Buffer.Byte := (
   16#00#, 16#01#, 16#02#, 16#03#, 16#37#, 16#2d#, 16#2e#, 16#2f#, 
   16#16#, 16#05#, 16#25#, 16#0b#, 16#0c#, 16#0d#, 16#0e#, 16#0f#, 
   16#10#, 16#11#, 16#12#, 16#13#, 16#3c#, 16#3d#, 16#32#, 16#26#, 
   16#18#, 16#19#, 16#3f#, 16#27#, 16#1c#, 16#1d#, 16#1e#, 16#1f#, 
   16#40#, 16#5a#, 16#7f#, 16#7b#, 16#5b#, 16#6c#, 16#50#, 16#7d#, 
   16#4d#, 16#5d#, 16#5c#, 16#4e#, 16#6b#, 16#60#, 16#4b#, 16#61#, 
   16#f0#, 16#f1#, 16#f2#, 16#f3#, 16#f4#, 16#f5#, 16#f6#, 16#f7#, 
   16#f8#, 16#f9#, 16#7a#, 16#5e#, 16#4c#, 16#7e#, 16#6e#, 16#6f#, 
   16#7c#, 16#c1#, 16#c2#, 16#c3#, 16#c4#, 16#c5#, 16#c6#, 16#c7#, 
   16#c8#, 16#c9#, 16#d1#, 16#d2#, 16#d3#, 16#d4#, 16#d5#, 16#d6#, 
   16#d7#, 16#d8#, 16#d9#, 16#e2#, 16#e3#, 16#e4#, 16#e5#, 16#e6#, 
   16#e7#, 16#e8#, 16#e9#, 16#ba#, 16#e0#, 16#bb#, 16#b0#, 16#6d#, 
   16#79#, 16#81#, 16#82#, 16#83#, 16#84#, 16#85#, 16#86#, 16#87#, 
   16#88#, 16#89#, 16#91#, 16#92#, 16#93#, 16#94#, 16#95#, 16#96#, 
   16#97#, 16#98#, 16#99#, 16#a2#, 16#a3#, 16#a4#, 16#a5#, 16#a6#, 
   16#a7#, 16#a8#, 16#a9#, 16#c0#, 16#4f#, 16#d0#, 16#a1#, 16#07#, 
   16#20#, 16#21#, 16#22#, 16#23#, 16#24#, 16#15#, 16#06#, 16#17#, 
   16#28#, 16#29#, 16#2a#, 16#2b#, 16#2c#, 16#09#, 16#0a#, 16#1b#, 
   16#30#, 16#31#, 16#1a#, 16#33#, 16#34#, 16#35#, 16#36#, 16#08#, 
   16#38#, 16#39#, 16#3a#, 16#3b#, 16#04#, 16#14#, 16#3e#, 16#ff#, 
   16#41#, 16#aa#, 16#4a#, 16#b1#, 16#9f#, 16#b2#, 16#6a#, 16#b5#, 
   16#bd#, 16#b4#, 16#9a#, 16#8a#, 16#5f#, 16#ca#, 16#af#, 16#bc#, 
   16#90#, 16#8f#, 16#ea#, 16#fa#, 16#be#, 16#a0#, 16#b6#, 16#b3#, 
   16#9d#, 16#da#, 16#9b#, 16#8b#, 16#b7#, 16#b8#, 16#b9#, 16#ab#, 
   16#64#, 16#65#, 16#62#, 16#66#, 16#63#, 16#67#, 16#9e#, 16#68#, 
   16#74#, 16#71#, 16#72#, 16#73#, 16#78#, 16#75#, 16#76#, 16#77#, 
   16#ac#, 16#69#, 16#ed#, 16#ee#, 16#eb#, 16#ef#, 16#ec#, 16#bf#, 
   16#80#, 16#fd#, 16#fe#, 16#fb#, 16#fc#, 16#ad#, 16#ae#, 16#59#, 
   16#44#, 16#45#, 16#42#, 16#46#, 16#43#, 16#47#, 16#9c#, 16#48#, 
   16#54#, 16#51#, 16#52#, 16#53#, 16#58#, 16#55#, 16#56#, 16#57#, 
   16#8c#, 16#49#, 16#cd#, 16#ce#, 16#cb#, 16#cf#, 16#cc#, 16#e1#, 
   16#70#, 16#dd#, 16#de#, 16#db#, 16#dc#, 16#8d#, 16#8e#, 16#df#);

   ITable : constant array (Buffer.Byte) of Wide_Character := (
      Wide_Character'Val (16#00#),
      Wide_Character'Val (16#01#),
      Wide_Character'Val (16#02#),
      Wide_Character'Val (16#03#),
      Wide_Character'Val (16#9c#),
      Wide_Character'Val (16#09#),
      Wide_Character'Val (16#86#),
      Wide_Character'Val (16#7f#),
      Wide_Character'Val (16#97#),
      Wide_Character'Val (16#8d#),
      Wide_Character'Val (16#8e#),
      Wide_Character'Val (16#0b#),
      Wide_Character'Val (16#0c#),
      Wide_Character'Val (16#0d#),
      Wide_Character'Val (16#0e#),
      Wide_Character'Val (16#0f#),
      Wide_Character'Val (16#10#),
      Wide_Character'Val (16#11#),
      Wide_Character'Val (16#12#),
      Wide_Character'Val (16#13#),
      Wide_Character'Val (16#9d#),
      Wide_Character'Val (16#85#),
      Wide_Character'Val (16#08#),
      Wide_Character'Val (16#87#),
      Wide_Character'Val (16#18#),
      Wide_Character'Val (16#19#),
      Wide_Character'Val (16#92#),
      Wide_Character'Val (16#8f#),
      Wide_Character'Val (16#1c#),
      Wide_Character'Val (16#1d#),
      Wide_Character'Val (16#1e#),
      Wide_Character'Val (16#1f#),
      Wide_Character'Val (16#80#),
      Wide_Character'Val (16#81#),
      Wide_Character'Val (16#82#),
      Wide_Character'Val (16#83#),
      Wide_Character'Val (16#84#),
      Wide_Character'Val (16#0a#),
      Wide_Character'Val (16#17#),
      Wide_Character'Val (16#1b#),
      Wide_Character'Val (16#88#),
      Wide_Character'Val (16#89#),
      Wide_Character'Val (16#8a#),
      Wide_Character'Val (16#8b#),
      Wide_Character'Val (16#8c#),
      Wide_Character'Val (16#05#),
      Wide_Character'Val (16#06#),
      Wide_Character'Val (16#07#),
      Wide_Character'Val (16#90#),
      Wide_Character'Val (16#91#),
      Wide_Character'Val (16#16#),
      Wide_Character'Val (16#93#),
      Wide_Character'Val (16#94#),
      Wide_Character'Val (16#95#),
      Wide_Character'Val (16#96#),
      Wide_Character'Val (16#04#),
      Wide_Character'Val (16#98#),
      Wide_Character'Val (16#99#),
      Wide_Character'Val (16#9a#),
      Wide_Character'Val (16#9b#),
      Wide_Character'Val (16#14#),
      Wide_Character'Val (16#15#),
      Wide_Character'Val (16#9e#),
      Wide_Character'Val (16#1a#),
      Wide_Character'Val (16#20#),
      Wide_Character'Val (16#a0#),
      Wide_Character'Val (16#e2#),
      Wide_Character'Val (16#e4#),
      Wide_Character'Val (16#e0#),
      Wide_Character'Val (16#e1#),
      Wide_Character'Val (16#e3#),
      Wide_Character'Val (16#e5#),
      Wide_Character'Val (16#e7#),
      Wide_Character'Val (16#f1#),
      Wide_Character'Val (16#a2#),
      Wide_Character'Val (16#2e#),
      Wide_Character'Val (16#3c#),
      Wide_Character'Val (16#28#),
      Wide_Character'Val (16#2b#),
      Wide_Character'Val (16#7c#),
      Wide_Character'Val (16#26#),
      Wide_Character'Val (16#e9#),
      Wide_Character'Val (16#ea#),
      Wide_Character'Val (16#eb#),
      Wide_Character'Val (16#e8#),
      Wide_Character'Val (16#ed#),
      Wide_Character'Val (16#ee#),
      Wide_Character'Val (16#ef#),
      Wide_Character'Val (16#ec#),
      Wide_Character'Val (16#df#),
      Wide_Character'Val (16#21#),
      Wide_Character'Val (16#24#),
      Wide_Character'Val (16#2a#),
      Wide_Character'Val (16#29#),
      Wide_Character'Val (16#3b#),
      Wide_Character'Val (16#ac#),
      Wide_Character'Val (16#2d#),
      Wide_Character'Val (16#2f#),
      Wide_Character'Val (16#c2#),
      Wide_Character'Val (16#c4#),
      Wide_Character'Val (16#c0#),
      Wide_Character'Val (16#c1#),
      Wide_Character'Val (16#c3#),
      Wide_Character'Val (16#c5#),
      Wide_Character'Val (16#c7#),
      Wide_Character'Val (16#d1#),
      Wide_Character'Val (16#a6#),
      Wide_Character'Val (16#2c#),
      Wide_Character'Val (16#25#),
      Wide_Character'Val (16#5f#),
      Wide_Character'Val (16#3e#),
      Wide_Character'Val (16#3f#),
      Wide_Character'Val (16#f8#),
      Wide_Character'Val (16#c9#),
      Wide_Character'Val (16#ca#),
      Wide_Character'Val (16#cb#),
      Wide_Character'Val (16#c8#),
      Wide_Character'Val (16#cd#),
      Wide_Character'Val (16#ce#),
      Wide_Character'Val (16#cf#),
      Wide_Character'Val (16#cc#),
      Wide_Character'Val (16#60#),
      Wide_Character'Val (16#3a#),
      Wide_Character'Val (16#23#),
      Wide_Character'Val (16#40#),
      Wide_Character'Val (16#27#),
      Wide_Character'Val (16#3d#),
      Wide_Character'Val (16#22#),
      Wide_Character'Val (16#d8#),
      Wide_Character'Val (16#61#),
      Wide_Character'Val (16#62#),
      Wide_Character'Val (16#63#),
      Wide_Character'Val (16#64#),
      Wide_Character'Val (16#65#),
      Wide_Character'Val (16#66#),
      Wide_Character'Val (16#67#),
      Wide_Character'Val (16#68#),
      Wide_Character'Val (16#69#),
      Wide_Character'Val (16#ab#),
      Wide_Character'Val (16#bb#),
      Wide_Character'Val (16#f0#),
      Wide_Character'Val (16#fd#),
      Wide_Character'Val (16#fe#),
      Wide_Character'Val (16#b1#),
      Wide_Character'Val (16#b0#),
      Wide_Character'Val (16#6a#),
      Wide_Character'Val (16#6b#),
      Wide_Character'Val (16#6c#),
      Wide_Character'Val (16#6d#),
      Wide_Character'Val (16#6e#),
      Wide_Character'Val (16#6f#),
      Wide_Character'Val (16#70#),
      Wide_Character'Val (16#71#),
      Wide_Character'Val (16#72#),
      Wide_Character'Val (16#aa#),
      Wide_Character'Val (16#ba#),
      Wide_Character'Val (16#e6#),
      Wide_Character'Val (16#b8#),
      Wide_Character'Val (16#c6#),
      Wide_Character'Val (16#a4#),
      Wide_Character'Val (16#b5#),
      Wide_Character'Val (16#7e#),
      Wide_Character'Val (16#73#),
      Wide_Character'Val (16#74#),
      Wide_Character'Val (16#75#),
      Wide_Character'Val (16#76#),
      Wide_Character'Val (16#77#),
      Wide_Character'Val (16#78#),
      Wide_Character'Val (16#79#),
      Wide_Character'Val (16#7a#),
      Wide_Character'Val (16#a1#),
      Wide_Character'Val (16#bf#),
      Wide_Character'Val (16#d0#),
      Wide_Character'Val (16#dd#),
      Wide_Character'Val (16#de#),
      Wide_Character'Val (16#ae#),
      Wide_Character'Val (16#5e#),
      Wide_Character'Val (16#a3#),
      Wide_Character'Val (16#a5#),
      Wide_Character'Val (16#b7#),
      Wide_Character'Val (16#a9#),
      Wide_Character'Val (16#a7#),
      Wide_Character'Val (16#b6#),
      Wide_Character'Val (16#bc#),
      Wide_Character'Val (16#bd#),
      Wide_Character'Val (16#be#),
      Wide_Character'Val (16#5b#),
      Wide_Character'Val (16#5d#),
      Wide_Character'Val (16#af#),
      Wide_Character'Val (16#a8#),
      Wide_Character'Val (16#b4#),
      Wide_Character'Val (16#d7#),
      Wide_Character'Val (16#7b#),
      Wide_Character'Val (16#41#),
      Wide_Character'Val (16#42#),
      Wide_Character'Val (16#43#),
      Wide_Character'Val (16#44#),
      Wide_Character'Val (16#45#),
      Wide_Character'Val (16#46#),
      Wide_Character'Val (16#47#),
      Wide_Character'Val (16#48#),
      Wide_Character'Val (16#49#),
      Wide_Character'Val (16#ad#),
      Wide_Character'Val (16#f4#),
      Wide_Character'Val (16#f6#),
      Wide_Character'Val (16#f2#),
      Wide_Character'Val (16#f3#),
      Wide_Character'Val (16#f5#),
      Wide_Character'Val (16#7d#),
      Wide_Character'Val (16#4a#),
      Wide_Character'Val (16#4b#),
      Wide_Character'Val (16#4c#),
      Wide_Character'Val (16#4d#),
      Wide_Character'Val (16#4e#),
      Wide_Character'Val (16#4f#),
      Wide_Character'Val (16#50#),
      Wide_Character'Val (16#51#),
      Wide_Character'Val (16#52#),
      Wide_Character'Val (16#b9#),
      Wide_Character'Val (16#fb#),
      Wide_Character'Val (16#fc#),
      Wide_Character'Val (16#f9#),
      Wide_Character'Val (16#fa#),
      Wide_Character'Val (16#ff#),
      Wide_Character'Val (16#5c#),
      Wide_Character'Val (16#f7#),
      Wide_Character'Val (16#53#),
      Wide_Character'Val (16#54#),
      Wide_Character'Val (16#55#),
      Wide_Character'Val (16#56#),
      Wide_Character'Val (16#57#),
      Wide_Character'Val (16#58#),
      Wide_Character'Val (16#59#),
      Wide_Character'Val (16#5a#),
      Wide_Character'Val (16#b2#),
      Wide_Character'Val (16#d4#),
      Wide_Character'Val (16#d6#),
      Wide_Character'Val (16#d2#),
      Wide_Character'Val (16#d3#),
      Wide_Character'Val (16#d5#),
      Wide_Character'Val (16#30#),
      Wide_Character'Val (16#31#),
      Wide_Character'Val (16#32#),
      Wide_Character'Val (16#33#),
      Wide_Character'Val (16#34#),
      Wide_Character'Val (16#35#),
      Wide_Character'Val (16#36#),
      Wide_Character'Val (16#37#),
      Wide_Character'Val (16#38#),
      Wide_Character'Val (16#39#),
      Wide_Character'Val (16#b3#),
      Wide_Character'Val (16#db#),
      Wide_Character'Val (16#dc#),
      Wide_Character'Val (16#d9#),
      Wide_Character'Val (16#da#),
      Wide_Character'Val (16#9f#));

   procedure Append (
      P : Page_037;
      V : in out Byte_Vectors.Vector;
      S : Wide_String) is
      C : Integer;
      B : Buffer.Byte;
   begin

      for J in S'Range loop
         C := Wide_Character'Pos (S (J));
         if C < 256 then
            V.Append (Table (Buffer.Byte (C)));
         elsif S (J) = Wide_Character'Val (
            Unicode.Names.General_Punctuation.En_Dash)
         then

            --
            --  Lossy conversion of en dash
            --  Em dash is dealt with at a higher level
            --

            V.Append (Table (Character'Pos ('-')));
         elsif S (J) = Wide_Character'Val (
            Unicode.Names.General_Punctuation.Left_Single_Quotation_Mark)
         then

            --
            --  Lossy conversion of directional quotation marks
            --

            V.Append (Table (Character'Pos (
               Ada.Characters.Latin_1.Apostrophe)));
         elsif S (J) = Wide_Character'Val (
            Unicode.Names.General_Punctuation.Right_Single_Quotation_Mark)
         then
            V.Append (Table (Character'Pos (
               Ada.Characters.Latin_1.Apostrophe)));
         elsif S (J) = Wide_Character'Val (
            Unicode.Names.General_Punctuation.Left_Double_Quotation_Mark)
         then
            V.Append (Table (Character'Pos ('"')));
         elsif S (J) = Wide_Character'Val (
            Unicode.Names.General_Punctuation.Right_Double_Quotation_Mark)
         then
            V.Append (Table (Character'Pos ('"')));
         else
            Code_Page_310.Append (V, S (J));
         end if;
      end loop;

   end Append;

   function To_Wide_Character (
      P : Page_037;
      B : Buffer.Byte) return Wide_Character is
   begin

      return ITable (B);

   end To_Wide_Character;

end Code_Page_037;
