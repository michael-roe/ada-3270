with Views;

package Pannable_Views is

   type Pannable_View is interface;

   procedure Pan_Left (V : in out Pannable_View) is abstract;

   procedure Pan_Right (V : in out Pannable_View) is abstract;

   type Pannable_Access is access all Pannable_View'Class;

end Pannable_Views;
