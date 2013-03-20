with TJa.Calendar;          use TJa.Calendar;
with TJa.Socket;            use TJa.Socket;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

type Str renames Ada.Strings.Unbounded.Unbounded_String;


package body Protocol is
   
   function To_Message(Msg_S : Str) return Message_Type is
      Msg : Message_Type;
   begin
      Msg.Time    := To_Time_Type(Slice(Msg_S, 1, 8));
      Msg.Header  := To_String(Slice(Msg_S, 9, 10))(1);
      Msg.Message := Slice(Msg_S, 11, Lenght(Msg_S));
      return Msg;
   end To_Message;
   
   function To_String(Message : Message_Type) return Str is
      Msg_S : Str;
   begin
      Append(Msg_S, To_String(Message.Time) & " ");
      Append(Msg_S, Message.Header & " ");
      Append(Msg_S, Message.Message);
      return Msg_S;
   end To_String;
   
   function Get_Message(Socket : Socket_Type) return Message_Type is
      Msg_S : Str;
   begin
      Get_Line(Socket, Msg_S);
      return To_Message(Msg_S);
   end Get_Message;
   
   function Init(Nickname : Str) return Socket_Type is
      Socket : Socket_Type;
      Msg    : Message_Type;
   begin
      Initiate(Socket);
      Connect(Socket, "localhost", 3400);
      Msg = Get_Message(Socket);
      Interpret_Initiation(Msg); --throws exception if "NO"
      Send_Nickname(Socket, Nickname);
      Msg = Get_Message(Socket);
      Interpret_Confirmation(Msg);
      return Socket;
   end Init;
   
   procedure Interpret_Confirmation(Message: in Message_Type) is
   begin
      if(Message.Header /= 'C') then
	 raise Wrong_Header;
      end if;
      if(Message.Message /= "OK") then
	 if(Message.Message = "INVALID") then
	    --                                                                   SKRIV VIDARE HÄR
	 end if;
	raise Recected_By_Server;
      end if;
   end Interpret_Confirmation;
   
   
   procedure Send_Nickname(Socket: in Socket_Type; Name: in Str) is
      Msg: Message_Type;
   begin
      Msg.Time := Get_Time(Clock);
      Msg.Header := 'N';
      Msg.Message := Name;
      Send(Msg);
   end Send_Nickname;
 
   
   procedure Send(Socket: in Socket_Type; Message: in Message_Type) is
   begin
      Put_Line(Socket, To_String(Message));
   end Send;
   
   
   procedure Interpret_Initiation(Message : in Message_Type) is --"InitieRING ist?"
   begin
      if(Message.Header /= 'I') then
	 raise Wrong_Header;
      end if;
      if(Message.Message /= "OK")
	raise Recected_By_Server;
      end if;
   end Interpret_Confirmation;
   
end Protocol;
