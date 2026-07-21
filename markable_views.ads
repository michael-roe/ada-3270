package Markable_Views is

   type Markable_View is interface;

   procedure Mark (
      V : in out Markable_View;
      X : Natural;
      Y : Natural) is abstract;

   procedure Unmark (V : in out Markable_View) is abstract;

   type Markable_Access is access all Markable_View'Class;

end Markable_Views;
