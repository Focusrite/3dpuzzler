with TJa.Calendar;          use TJa.Calendar;
with TJa.Socket;            use TJa.Socket;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

type Str renames Ada.Strings.Unbounded.Unbounded_String;

package Protocol is
   type Message_Type is private;
   
   function Init(Nickname : Str) return Socket_Type;
   function Get_Message(Socket : Socket_Type) return Message_Type;
   procedure Interpret_Message(Message : in Message_Type);
   function To_String(Message : Message_Type) return Str;
   
   -- Exceptions
   Rejected_By_Server: Exception;
   Wrong_Header: Exception;
   
private
   type Message_Type is
      record
	 Time_Type : Time;
	 Character : Header;
	 Message   : Str;
      end record;
   
   
   function To_Message(Msg_S :  Str) return Message_Type;
   
   -- Interpret Messages Procedures
   procedure Interpret_Confirmation(Message : in Message_Type);
   procedure Interpret_Parts(Message : in Message_Type);
   procedure Interpret_Figure(Message : in Message_Type);
   procedure Interpret_Answer(Message : in Message_Type);
   procedure Interpret_Done(Message : in Message_Type);
   procedure Interpret_Update_Highscore(Message : in Message_Type);
   procedure Interpret_All_Done(Message : in Message_Type);
   procedure Interpret_Terminate(Message : in Message_Type);
   
   -- Message Creation
   function Send_Nickname(Socket : in Socket_Type; Name : in Str);
   
   procedure Send(Socket : in Socket_Type; Message : in Message_Type);
      
end Protocol;
