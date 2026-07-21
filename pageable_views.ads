package Pageable_Views is

   type Pageable_View is interface;

   procedure Prev_Page (V : in out Pageable_View) is abstract;

   procedure Next_Page (V : in out Pageable_View) is abstract;

   type Pageable_Access is access all Pageable_View'Class;

end Pageable_Views;
