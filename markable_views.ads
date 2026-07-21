package Markable_Views is

   type Markable_View is interface;

   procedure Mark (
      V : in out Markable_View;
      X : Natural;
      Y : Natural) is abstract;

   procedure Unmark (V : in out Markable_View) is abstract;

end Markable_Views;
