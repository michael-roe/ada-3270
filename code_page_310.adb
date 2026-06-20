with IBM_3270;

package body Code_Page_310 is

   type Mapping is record
      From : Wide_Character;
      To : Buffer.Byte;
   end record;

   subtype Table_Index is Integer range 0 .. 57;

   Table : constant array (Table_Index) of Mapping :=
   (
(Wide_Character'Val (16#2070#), Buffer.Byte (16#f0#)),
(Wide_Character'Val (16#2074#), Buffer.Byte (16#f4#)),
(Wide_Character'Val (16#2075#), Buffer.Byte (16#f5#)),
(Wide_Character'Val (16#2076#), Buffer.Byte (16#f6#)),
(Wide_Character'Val (16#2077#), Buffer.Byte (16#f7#)),
(Wide_Character'Val (16#2078#), Buffer.Byte (16#f8#)),
(Wide_Character'Val (16#2079#), Buffer.Byte (16#f9#)),
(Wide_Character'Val (16#207a#), Buffer.Byte (16#c2#)),
(Wide_Character'Val (16#207d#), Buffer.Byte (16#c1#)),
(Wide_Character'Val (16#207e#), Buffer.Byte (16#d1#)),
(Wide_Character'Val (16#2081#), Buffer.Byte (16#e1#)),
(Wide_Character'Val (16#2082#), Buffer.Byte (16#e2#)),
(Wide_Character'Val (16#2083#), Buffer.Byte (16#e3#)),
(Wide_Character'Val (16#208b#), Buffer.Byte (16#d2#)),
(Wide_Character'Val (16#2099#), Buffer.Byte (16#a4#)),
(Wide_Character'Val (16#2190#), Buffer.Byte (16#9f#)),
(Wide_Character'Val (16#2191#), Buffer.Byte (16#8a#)),
(Wide_Character'Val (16#2192#), Buffer.Byte (16#8f#)),
(Wide_Character'Val (16#2193#), Buffer.Byte (16#8b#)),
(Wide_Character'Val (16#2206#), Buffer.Byte (16#bb#)),
(Wide_Character'Val (16#2207#), Buffer.Byte (16#ba#)),
(Wide_Character'Val (16#220e#), Buffer.Byte (16#c3#)),
(Wide_Character'Val (16#2218#), Buffer.Byte (16#af#)),
(Wide_Character'Val (16#2219#), Buffer.Byte (16#a3#)),
(Wide_Character'Val (16#2227#), Buffer.Byte (16#71#)),
(Wide_Character'Val (16#2228#), Buffer.Byte (16#78#)),
(Wide_Character'Val (16#2229#), Buffer.Byte (16#aa#)),
(Wide_Character'Val (16#222a#), Buffer.Byte (16#ab#)),
(Wide_Character'Val (16#2235#), Buffer.Byte (16#ec#)),
(Wide_Character'Val (16#2260#), Buffer.Byte (16#be#)),
(Wide_Character'Val (16#2261#), Buffer.Byte (16#e0#)),
(Wide_Character'Val (16#2264#), Buffer.Byte (16#8c#)),
(Wide_Character'Val (16#2265#), Buffer.Byte (16#ae#)),
(Wide_Character'Val (16#2282#), Buffer.Byte (16#9b#)),
(Wide_Character'Val (16#2283#), Buffer.Byte (16#9a#)),
(Wide_Character'Val (16#22a4#), Buffer.Byte (16#bc#)),
(Wide_Character'Val (16#22a5#), Buffer.Byte (16#ac#)),
(Wide_Character'Val (16#2308#), Buffer.Byte (16#8d#)),
(Wide_Character'Val (16#230a#), Buffer.Byte (16#8e#)),
(Wide_Character'Val (16#2342#), Buffer.Byte (16#ce#)),
(Wide_Character'Val (16#2395#), Buffer.Byte (16#90#)),
(Wide_Character'Val (16#2500#), Buffer.Byte (16#a2#)),
(Wide_Character'Val (16#2502#), Buffer.Byte (16#85#)),
(Wide_Character'Val (16#250c#), Buffer.Byte (16#c5#)),
(Wide_Character'Val (16#2510#), Buffer.Byte (16#d5#)),
(Wide_Character'Val (16#2514#), Buffer.Byte (16#c4#)),
(Wide_Character'Val (16#2518#), Buffer.Byte (16#d4#)),
(Wide_Character'Val (16#251c#), Buffer.Byte (16#c6#)),
(Wide_Character'Val (16#2524#), Buffer.Byte (16#d6#)),
(Wide_Character'Val (16#252c#), Buffer.Byte (16#d7#)),
(Wide_Character'Val (16#2534#), Buffer.Byte (16#c7#)),
(Wide_Character'Val (16#253c#), Buffer.Byte (16#d3#)),
(Wide_Character'Val (16#2580#), Buffer.Byte (16#93#)),
(Wide_Character'Val (16#2584#), Buffer.Byte (16#94#)),
(Wide_Character'Val (16#2588#), Buffer.Byte (16#95#)),
(Wide_Character'Val (16#258c#), Buffer.Byte (16#91#)),
(Wide_Character'Val (16#2590#), Buffer.Byte (16#92#)),
(Wide_Character'Val (16#25ca#), Buffer.Byte (16#70#))
   );

   procedure Append (V : in out Byte_Vectors.Vector; S : Wide_Character) is
   begin
      for J in Table_Index loop
         if Table (J).From = S then
            V.Append (IBM_3270.Graphic_Escape);
            V.Append (Table (J).To);
         end if;
      end loop;
   end Append;

end Code_Page_310;
