with Ada.Text_IO; use Ada.Text_IO;

package body Runtime is
   
   procedure Run is
      Part_List: aliased Figure_List_Type;
      Socket : Socket_Type;
      Puzzle_Figure: Figure_Access;
      Correct : Boolean;
   begin
      Socket := Init(Str.To_Unbounded_String("BestTeamEver"));
      Part_List := Receive_Parts(Socket);
      loop
       	 begin
	    Puzzle_Figure := Receive_Figure(Socket);
	    Solve(Part_List, Puzzle_Figure); -- DUMMY
	    Send_Solution(Socket, Part_List, Puzzle_Figure);
	    Correct := Receive_Answer(Socket);
	    if Correct then
	      Put("Rätt!");
	    else
	       Put("Fel!");
	    end if;
	    
	 --exception
	 --   when others =>
	 --      return;
	    --om terminate, avsluta
	 end;
	 --exit when fått nånting done
      end loop;
   end Run;
   
   
end Runtime;
