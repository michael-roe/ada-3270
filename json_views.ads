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

end JSON_Views;
