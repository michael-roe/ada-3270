with Buffer;
with Buffer_Queues;
with Byte_Vectors;
with Views;
with Paged_Views;
with JSON_Views;
with Lines;

package Menu_Views is

   Max_Items : constant := 6;

   type Label_Array is array (1 .. Max_Items) of Lines.Bounded_Wide_String;

   type Menu_View is new Paged_Views.Paged_View
     and JSON_Views.JSON_View with record
      AID    : Buffer.Byte;
      Title  : Lines.Bounded_Wide_String;
      Intro  : Lines.Bounded_Wide_String;
      Labels : Label_Array;
      Option : Natural;
   end record;

   procedure To_Physical (
      V : Menu_View;
      Bytes_Out : in out Byte_Vectors.Vector);

   procedure From_Physical (
      V : in out Menu_View;
      Bytes_In : Byte_Vectors.Vector);

   procedure Update_AID (
      V : in out Menu_View;
      AID : Buffer.Byte);

   procedure Update_Cursor (
      V : in out Menu_View;
      X : Natural;
      Y : Natural);

   procedure Update_Field (
      V : in out Menu_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String);

   function Get_AID (V : Menu_View) return Buffer.Byte;

   procedure Set_Title (
      V : in out Menu_View;
      L : Lines.Bounded_Wide_String);

   procedure Prev_Page (V : in out Menu_View);

   procedure Next_Page (V : in out Menu_View);

   procedure To_JSON (
      V   : Menu_View;
      TX2 : access Buffer_Queues.Queue);

   procedure Set_Label (
      V : in out Menu_View;
      N : Natural;
      L : Lines.Bounded_Wide_String);

end Menu_Views;
