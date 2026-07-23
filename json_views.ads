with Buffer_Queues;

package JSON_Views is

   type JSON_View is interface;

   --
   --  JSON_View is used for views that can create a JSON
   --  representation of the contents of their input fields.
   --

   procedure To_JSON (
      V   : JSON_View;
      TX2 : access Buffer_Queues.Queue) is abstract;

   type JSON_Access is access all JSON_View'Class;

end JSON_Views;
