with Ada.Text_IO; use Ada.Text_IO;

package body Runtime is
   
   procedure Run is
      Part_List: Figure_List_Type;
      Socket : Socket_Type;
      
      Correct : Boolean;
   begin
      loop
	 begin
	    Socket := Init(Str.To_Unbounded_String("Best Team Ever"));
	    Part_List := Receive_Parts(Socket);
	    Solve(Part_List, Receive_Figure(Socket)); -- DUMMY
	    Send_Solution(Socket, Part_List);
	    Correct := Receive_Answer(Socket);
	    if Correct then
	      Put("Rätt!");
	    else
	       Put("Fel!");
	    end if;
	    
	 exception
	    when others =>
	       return;
	    --om terminate, avsluta
	 end;
	 --exit when fått nånting done
      end loop;
   end Run;
   
   
end Runtime;
