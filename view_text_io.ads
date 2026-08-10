with Ada.Strings.Unbounded;
with Outputable_Views;

package View_Text_IO is

   procedure Put (
      V : Outputable_Views.Outputable_Access;
      S : Ada.Strings.Unbounded.Unbounded_String); 

   --
   --  S is UTF8 encoded
   --

end View_Text_IO;
