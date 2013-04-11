with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body Protocol is
   
   --converts str type to message type, able to be sent
   function To_Message(Msg_S : Unbounded_String) return Message_Type is
      Msg : Message_Type;
   begin
      
      New_Line;
      Put(">>|");
      Put(To_String(Msg_S));
      Put("|");
      New_Line;
      
      
      Msg.Time	  := To_Time_Type(Slice(Msg_S, 1, 8));
      Msg.Header  := Slice(Msg_S, 9, 10)(10);
      Msg.Message := To_Unbounded_String(Slice(Msg_S, 12, Length(Msg_S)));
      return Msg;
   end To_Message;

   --converts a message type from the msg-system to a str
   function To_String(Message : Message_Type) return Unbounded_String is
      Msg_S : Unbounded_String;
   begin
      Append(Msg_S, To_String(Message.Time) & " ");
      Append(Msg_S, Message.Header & " ");
      Append(Msg_S, Message.Message);
      
      New_Line;
      Put("<<|");
      Put(To_String(Msg_S));
      Put("|");
      New_Line;
      
      return Msg_S;
   end To_String;

   --Waits for a message from a socket
   function Get_Message(Socket : Socket_Type) return Message_Type is
      Msg_S : Unbounded_String;
   begin
      Get_Line(Socket, Msg_S);
      return To_Message(Msg_S);
   end Get_Message;

   -- Takes care of the first three parts of the protocol
   function Init(Nickname : Unbounded_String) return Socket_Type is
      Socket : Socket_Type;
      Msg	 : Message_Type;
   begin
      Initiate(Socket);
      Connect(Socket, "localhost", 3400);
      Msg := Get_Message(Socket);
      Interpret_Initiation(Msg); --throws exception if "NO"
      Send_Nickname(Socket, To_String(Nickname));
      Msg := Get_Message(Socket);
      while not Interpret_Confirmation(Msg) loop --Loop till ok nick
	 Handle_New_Nick(Socket); --prompts and sends new nickname
      end loop;
      return Socket;
   end Init;
   
   procedure Solution_Message_Str(Solved_Figure_List: in out Figure_List_Type;
				  Figure: in Figure_Access; 
				  O_String : out Unbounded_String) is
      Resultstr: Unbounded_String := To_Unbounded_String("");
      Current_Part: Figure_Access;
      Id_String: String := Integer'Image(Get_Id(Figure));
   begin
      First(Solved_Figure_List, Current_Part);
      loop --'image sätter mellanslag innan varje
	 Resultstr := Resultstr & " !"
	   & Integer'Image(Get_Rotation(Current_Part.all, AXIS_X)) -- kanske måste referera till .all
	   & Integer'Image(Get_Rotation(Current_Part.all, AXIS_Y))
	   & Integer'Image(Get_Rotation(Current_Part.all, AXIS_Z))
	   & Integer'Image(Get_Rotation(Current_Part.all, AXIS_X))
	   & Integer'Image(Get_Rotation(Current_Part.all, AXIS_Y))
	   & Integer'Image(Get_Rotation(Current_Part.all, AXIS_Z));
	 
	 exit when Last_Element(Solved_Figure_List) = Current_Part.all;
	 Next(Solved_Figure_List, Current_Part);
      end loop;
      O_String := To_Unbounded_String(Id_String(2..Id_String'Last)) & Resultstr;
   end Solution_Message_Str;
   
   procedure Send_Solution(Socket: in Socket_Type; List: in out Figure_List_Type; Figure: in Figure_Access) is
      Solution_Message: Message_Type;
      S_String : Unbounded_String;
   begin
      Solution_Message.Header := 'S';
      Solution_Message_Str(List, Figure, S_String);
      Solution_Message.Message := S_String;
      Solution_Message.Time := Get_Time(Clock);
      Send(Socket, Solution_Message);
   end Send_Solution;

   procedure Give_Up(Socket: in Socket_Type; Number: in Integer) is
      Give_Up_Message: Message_Type;
      Number_Image: String := Integer'Image(Number);
   begin
      Give_Up_Message.Header := 'G';
      Give_Up_Message.Message := To_Unbounded_String(Number_Image(2..Number_Image'Last));
      Give_Up_Message.Time := Get_Time(Clock);
      Send(Socket, Give_Up_Message); 
   end Give_Up;
   
   procedure Figure_Header_And_Number(Figure_Message: in Message_Type; Figure_Number: out Integer) is
   begin
      if Figure_Message.Header /= 'F' then
	 raise Wrong_Header;
      end if;
      Figure_Number := Integer'Value(
				     Slice(
					   Figure_Message.Message,
					   1,
					   Next_Space_Index(
							    Figure_Message.Message,
							    1)
					     - 1));
   end Figure_Header_And_Number;
   
   function Receive_Answer(Socket: in Socket_Type) return Boolean is 
   begin
      Put("Received Answer;");
      return TRUE;
   end Receive_Answer;
   
   
   
   --Receives the a figure from the server, returns it
   function Receive_Figure(Socket: in Socket_Type) return Figure_Access is
      Figure_Message: Message_Type;
      Msg: Unbounded_String;
      Shape_String: Unbounded_String;
      --	Dim_String: Unbounded_String; ta bort
      
      Start_Dim_Index: Integer := 0;
      Start_Shape_Index: Integer := 0;
      End_Shape_Index: Integer := 0;
      
      Dim_X, Dim_Y, Dim_Z: Integer;
      Figure_Number: Integer;

   begin
      Put(To_String(Figure_Message.Message));
      Figure_Message := Get_Message(Socket);
      Msg := Figure_Message.Message;
      Figure_Header_And_Number(Figure_Message, Figure_Number); --raises header exc if wrong
            
      Start_Dim_Index := Next_Space_Index(Msg, 1) + 1;
      Start_Shape_Index := Next_Space_Index(Msg, Start_Dim_Index) + 1; 
      Extract_Dimensions(Slice(Msg, Start_Dim_Index, Start_Shape_Index - 2),
			 Dim_X, Dim_Y, Dim_Z);
      
      End_Shape_Index := Start_Shape_Index + (Dim_X * Dim_Y * Dim_Z) - 1;
      Shape_String := To_Unbounded_String(Slice(Msg, Start_Shape_Index, End_Shape_Index));
      
      return New_Figure(Build_Shape(Shape_String, Dim_X, Dim_Y, Dim_Z), Figure_Number); 
      --Dummy-funktion! Se över detta med de andra!
   end Receive_Figure;
   
   
   function Build_Shape(Shape_Str : Unbounded_String; X, Y, Z : Integer) return Shape_Matrix is
      Shape : Shape_Matrix(1..X, 1..Y, 1..Z);
      Sh_Str: String := To_String(Shape_Str);
   begin
      for Zi in 1..Z loop
	 for Yi in 1..Y loop
	    for Xi in 1..X loop
	       if Sh_Str((Zi-1)*Y*X + (Yi-1)*X + (Xi-1) + 1) = '1' then
		  Shape(Xi, Yi, Zi) := TRUE;
	       else
		  Shape(Xi, Yi, Zi) := FALSE;
	       end if;
	    end loop;
	 end loop;
      end loop;
      return Shape;
   end Build_Shape;
   

   -- Receives the parts message and returns list of parts
   function Receive_Parts(Socket: in Socket_Type)
			 return Figure_List_Type is
      Part_Message: Message_Type;
      Msg: Unbounded_String;
      
      Number_Of_Parts: Integer;
      Shape_String: Unbounded_String;
      Dim_String: Unbounded_String;
      Start_Shape_Index: Integer := 0;
      
      Start_Dim_Index: Integer;
      Dim_X, Dim_Y, Dim_Z: Integer;
      
      Part_List: aliased Figure_List_Type;
      Part_Access : Figure_Access;
   begin
      
      Part_Message := Get_Message(Socket);
      Msg := Part_Message.Message;
      
      Number_Of_Parts := Extract_Number(Part_Message);
      Start_Dim_Index := Next_Space_Index(Msg, 1) + 1;
      for I in 1..Number_Of_Parts loop
	 -- OBS: Slice returnerar en standard-string
	 Dim_String := To_Unbounded_String(
					   Slice(
						 Msg,
						 Start_Dim_Index,
						 Next_Space_Index(Msg, Start_Dim_Index) - 1)); -- ta ut strängen som har dim ur msg
	 
	 Extract_Dimensions(To_String(Dim_String), Dim_X, Dim_Y, Dim_Z); --från string till int-värden
	 Start_Shape_Index := Next_Space_Index(Msg, Start_Dim_Index) + 1;
	 Shape_String := To_Unbounded_String(
					     Slice(
						   Msg,
						   Start_Shape_Index,
						   Start_Shape_Index + ((Dim_X * Dim_Y * Dim_Z) - 1)));  -- ta shape-sträng ur msg
	 --Part_Access := new Figure_Type(Dim_X, Dim_Y, Dim_Z);
	 Append(Part_List, New_Figure(Build_Shape(Shape_String, Dim_X, Dim_Y, Dim_Z), I));
	 if I /= Number_Of_Parts then -- om det inte är sista
				      --flytta fram indexar
	    Start_Dim_Index := Next_Space_Index(Msg, Start_Shape_Index) + 1;
	    Start_Shape_Index := Next_Space_Index(Msg, Start_Dim_Index) + 1;
	 end if;
      end loop;
      return Part_List;
   end Receive_Parts;
   
   procedure Extract_Dimensions(Dim_String: in String; X: out Integer; Y: out Integer; Z: out Integer) is
      
      Index1, Index2: Integer; -- indexar av de två 'x' i strängen
      Ds : Unbounded_String := To_Unbounded_String(Dim_String);
   begin
      Index1 := Next_Index(Ds, 1, "x");
      X := Integer'Value(Slice(Ds, 1, Index1 - 1));
      Index2 := Next_Index(Ds, Index1 + 1, "x");
      Y := Integer'Value(Slice(Ds, Index1 + 1, Index2 - 1)); --Testa slice, index kan va fel
      Z := Integer'Value(Slice(Ds, Index2 + 1, Length(Ds)));
   end Extract_Dimensions;
   
   --asks for new nick and sends it to the server
   procedure Handle_New_Nick(Socket: in Socket_Type) is 
      Nickname: String(1..20);
   begin
      Prompt_Nick(Nickname);
      Send_Nickname(Socket, Nickname);
   end Handle_New_Nick;

   --Promts the user for a new nickname
   procedure Prompt_Nick(Nickname: out String) is
      Length: Integer := 0;
      Temp_Nickname: String(1..20);
   begin
      Put("Enter new nickname: ");
      Get_Line(Temp_Nickname, Length); -- FIX LINE PROBLEM?
      if Length = 20 then
	 Skip_Line;
      end if;
      Nickname := Temp_Nickname(1..Length);
   end Prompt_Nick;
   
   --Interprets the parts message from the server
   --checks header and extracts the relevant data.
   function Extract_Number(Message: in Message_Type) return Integer is
      Index: Integer := 0;
      Msg: Unbounded_String := Message.Message; -- text part of message
   begin
      if(Message.Header /= 'P') then
	 raise Wrong_Header;
      end if;
      Index := Next_Space_Index(Msg, 1);
      return Integer'Value(Slice(Msg, 1, Index-1));
   end Extract_Number;
   
   --returns true if nick is ok
   function Interpret_Confirmation(Message: in Message_Type) return Boolean is
   begin
      if(Message.Header /= 'C') then
	 raise Wrong_Header;
      end if;
      if(Message.Message = "OK") then
	 return TRUE;
      end if;
      if(Message.Message = "INVALID") then
	 Put("Nickname invalid.");
	 New_Line;
	 return FALSE;
      end if;
      if(Message.Message = "UNAVAILABLE") then
	 Put("Nickname already in use");
	 New_Line;
	 return FALSE;
      end if;
      return FALSE;
   end Interpret_Confirmation;

   --Sends a nickname to the server
   procedure Send_Nickname(Socket: in Socket_Type; Name: in String) is
      Msg: Message_Type;
   begin
      Msg.Time := Get_Time(Clock);
      Msg.Header := 'N';
      Msg.Message := To_Unbounded_String(Name);
      Send(Socket, Msg);
   end Send_Nickname;

   --Sends a message to the server
   procedure Send(Socket: in Socket_Type; Message: in Message_Type) is
   begin
      Put_Line(Socket, To_String(Message));
   end Send;

   --interpret the intitiation message from the server
   procedure Interpret_Initiation(Message : in Message_Type) is --"InitieRING ist?"
   begin
      if(Message.Header /= 'I') then
	 raise Wrong_Header;
      end if;
      if(Message.Message /= "OK") then
	 raise Rejected_By_Server;
      end if;
   end Interpret_Initiation;

end Protocol;
