with Buffer;
with Byte_Vectors;
with Code_Pages;
with Paged_Views;
with Lines;
with Line_Vectors;

package Progress_Views is

   type Progress_View is new Paged_Views.Paged_View with private;

   procedure To_Physical (
      V : Progress_View;
      Bytes_Out : in out Byte_Vectors.Vector;
      P : Code_Pages.Code_Page_Access);

   procedure From_Physical (
      V : in out Progress_View;
      Bytes_In : Byte_Vectors.Vector;
      P : Code_Pages.Code_Page_Access);

   procedure Update_AID (
      V : in out Progress_View;
      AID : Buffer.Byte);

   procedure Update_Cursor (
      V : in out Progress_View;
      X : Natural;
      Y : Natural);

   procedure Update_Field (
      V : in out Progress_View;
      X : Natural;
      Y : Natural;
      L : Lines.Bounded_Wide_String);

   function Get_AID (V : Progress_View) return Buffer.Byte;

   procedure Set_Title (
      V : in out Progress_View;
      L : Lines.Bounded_Wide_String);

   procedure Prev_Page (V : in out Progress_View);

   procedure Next_Page (V : in out Progress_View);

   procedure Set_Intro (
      V : in out Progress_View;
      L : Lines.Bounded_Wide_String);

   procedure Set_Progress (
      V : in out Progress_View;
      Progress : Natural);

private

   type Progress_View is new Paged_Views.Paged_View with record
      AID : Buffer.Byte := 0;
      Title : Lines.Bounded_Wide_String;
      Intro : Lines.Bounded_Wide_String;
      Progress : Natural := 0;
   end record;

end Progress_Views;
