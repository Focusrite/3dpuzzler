with TJa.Calendar;          use TJa.Calendar;
with TJa.Sockets;           use TJa.Sockets;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Util;                  use Util;
with Figure;                use Figure;
with Figure_List;           use Figure_List;
with Geometry;              use Geometry;
with Shape;                 use Shape;

package Protocol is
   
   package Str renames Ada.Strings.Unbounded;
   
   type Message_Type is private;
   
   function Init(Nickname : Str.Unbounded_String) return Socket_Type;
   function Receive_Parts(Socket: in Socket_Type) return Figure_List_Type;
   function Receive_Figure(Socket: in Socket_Type) return Figure_Access;
   procedure Give_Up(Socket: in Socket_Type; Number: in Integer);
   procedure Send_Solution(Socket: in Socket_Type; List: in out Figure_List_Type; Figure: in Figure_Access);
   function Receive_Answer(Socket: in Socket_Type) return Boolean;
   function Build_Shape(Shape_Str : Unbounded_String; X, Y, Z : Integer) return Shape_Matrix;
   
   
   -- Exceptions
   Rejected_By_Server: Exception;
   Wrong_Header: Exception;
   
private
   type Message_Type is
      record
	 Time      : Time_Type;
	 Header    : Character;
	 Message   : Str.Unbounded_String;
      end record;
   
   
   
   -- Interpret Messages Procedures
   function To_Message(Msg_S :  Str.Unbounded_String) return Message_Type;
   function Get_Message(Socket : Socket_Type) return Message_Type;
   function To_String(Message : Message_Type) return Str.Unbounded_String;
   
   function Interpret_Confirmation(Message : in Message_Type) return Boolean;
   --procedure Interpret_Parts(Message : in Message_Type);
   --procedure Interpret_Figure(Message : in Message_Type);
   --procedure Interpret_Answer(Message : in Message_Type);
   --procedure Interpret_Done(Message : in Message_Type);
   --procedure Interpret_Update_Highscore(Message : in Message_Type);
   --procedure Interpret_All_Done(Message : in Message_Type);
   --procedure Interpret_Terminate(Message : in Message_Type);
   procedure Interpret_Initiation(Message : in Message_Type);
   
   procedure Solution_Message_Str(Solved_Figure_List: in out Figure_List_Type;
				  Figure: in Figure_Access;
				  O_String : out Unbounded_String);
   
   procedure Figure_Header_And_Number(Figure_Message: in Message_Type; Figure_Number: out Integer);
   
   -- Message Creation
   procedure Send_Nickname(Socket : in Socket_Type; Name : in String) ;
   
   procedure Send(Socket : in Socket_Type; Message : in Message_Type);
   
   -- Util
   procedure Extract_Dimensions(Dim_String: in String; X: out Integer; Y: out Integer; Z: out Integer);
   procedure Handle_New_Nick(Socket: in Socket_Type);
   procedure Prompt_Nick(Nickname: out String);
   function Extract_Number(Message: in Message_Type) return Integer;
      
end Protocol;
