with Views;

package Outputable_Views is

   type Outputable_View is interface;

   procedure Put_Character (
      V : in out Outputable_View;
      C : Wide_Character) is abstract;

   procedure New_Line (V : in out Outputable_View) is abstract;

   type Outputable_Access is access all Outputable_View'Class;

end Outputable_Views;
