with IBM_3270_Orders;

package IBM_3270.Drivers is

   type Driver is abstract tagged null record;

   procedure Update_Code_Page (
     D : in out Driver;
     Code_Page : Integer) is abstract;

   procedure Update_Highlighting (
      D : in out Driver;
      Highlighting : IBM_3270_Orders.Highlighting) is abstract;

   procedure Update_Reply_Mode (
      D : in out Driver;
      Reply_Mode : IBM_3270_Orders.Reply_Mode) is abstract;

   type Driver_Access is access all Driver'Class;

end IBM_3270.Drivers;
