with Ada.Streams;
with Buffer;
with Buffer_Queues;
with Byte_Vectors;
with Code_Pages;
with Paged_Views;
with Outputable_Views;
with JSON_Views;
with Lines;
with Line_Vectors;

package Split_Views is

   type Edit_Window is array (0 .. 17) of Lines.Bounded_Wide_String;

   type Split_View is new Paged_Views.Paged_View and
     Outputable_Views.Outputable_View and JSON_Views.JSON_View
     with private;

   procedure To_Physical (
      V : Split_View;
      Bytes_Out : in out Byte_Vectors.Vector;
      P : Code_Pages.Code_Page_Access);

   procedure From_Physical (
      V : in out Split_View;
      Bytes_In : Byte_Vectors.Vector;
      P : Code_Pages.Code_Page_Access);

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

   procedure Set_Title (
      V : in out Split_View;
      L : Lines.Bounded_Wide_String);

   procedure Prev_Page (V : in out Split_View);

   procedure Next_Page (V : in out Split_View);

   function Get_Option (V : Split_View) return Natural;

   procedure To_JSON (
      V   : Split_View;
      TX2 : access Buffer_Queues.Queue);

   procedure Set_Subtitle (
      V : in out Split_View;
      L : Lines.Bounded_Wide_String);

   procedure Edit_To_History (V : in out Split_View);

   procedure Put_Character (
      V : in out Split_View;
      C : Wide_Character);

   procedure New_Line (V : in out Split_View);

private

   type Split_View is new Paged_Views.Paged_View and
     Outputable_Views.Outputable_View and JSON_Views.JSON_View
     with record
      AID : Buffer.Byte := 0;
      Title : Lines.Bounded_Wide_String;
      Subtitle : Lines.Bounded_Wide_String;
      Page_Number : Natural := 0;
      History : Line_Vectors.Vector;
      Edit    : Edit_Window;
      Option  : Natural := 1;
   end record;

end Split_Views;
