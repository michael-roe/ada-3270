with Buffer;
with Byte_Vectors;
with Code_Pages;
with Paged_Views;
with Lines;
with Line_Vectors;

package Text_Views is

   type Text_View is new Paged_Views.Paged_View with private;

   procedure To_Physical (
      V : Text_View;
      Bytes_Out : in out Byte_Vectors.Vector;
      P : Code_Pages.Code_Page_Access);

   procedure From_Physical (
      V : in out Text_View;
      Bytes_In : Byte_Vectors.Vector;
      P : Code_Pages.Code_Page_Access);

   procedure Update_AID (
      V : in out Text_View;
      AID : Buffer.Byte);

   procedure Update_Cursor (
      V : in out Text_View;
      X : Natural;
      Y : Natural);

   procedure Update_Field (
      V : in out Text_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String);

   function Get_AID (V : Text_View) return Buffer.Byte;

   procedure Set_Title (
      V : in out Text_View;
      L : Lines.Bounded_Wide_String);

   procedure Prev_Page (V : in out Text_View);

   procedure Next_Page (V : in out Text_View);

   procedure Set_Subtitle (
      V : in out Text_View;
      L : Lines.Bounded_Wide_String);

private

   type Text_View is new Paged_Views.Paged_View with record
      AID : Buffer.Byte := 0;
      Title : Lines.Bounded_Wide_String;
      Subtitle : Lines.Bounded_Wide_String;
      Page_Number : Natural := 0;
      Text : Line_Vectors.Vector;
   end record;

end Text_Views;
