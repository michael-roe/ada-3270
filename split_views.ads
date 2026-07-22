with Ada.Streams;
with Buffer;
with Byte_Vectors;
with Paged_Views;
with Lines;
with Line_Vectors;
with Buffer_Queues;

package Split_Views is

   type Edit_Window is array (0 .. 18) of Lines.Bounded_Wide_String;

   type Split_View is new Paged_Views.Paged_View with record
      AID : Buffer.Byte := 0;
      Page_Number : Natural := 0;
      History : Line_Vectors.Vector;
      Edit    : Edit_Window;
   end record;

   procedure To_Physical (
      V : Split_View;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure From_Physical (
      V : in out Split_View;
      Bytes_In : Byte_Vectors.Vector);

   procedure Update_AID (
      V : in out Split_View;
      AID : Buffer.Byte);

   procedure Update_Cursor (
      V : in out Split_View;
      X : Natural;
      Y : Natural);

   procedure Update_Field (
      V : in out Split_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String);

   function Get_AID (V : Split_View) return Buffer.Byte;

   procedure Prev_Page (V : in out Split_View);

   procedure Next_Page (V : in out Split_View);

   procedure To_JSON (
      V   : Split_View;
      TX2 : access Buffer_Queues.Queue);

   procedure Edit_To_History (V : in out Split_View);

   procedure Put_Character (
      V : in out Split_View;
      C : Wide_Character);

   procedure New_Line (V : in out Split_View);

end Split_Views;
