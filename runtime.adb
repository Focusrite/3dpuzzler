with Ada.Text_IO; use Ada.Text_IO;

package body Runtime is
   
   procedure Run is
      Part_List: aliased Figure_List_Type;
      Socket : Socket_Type;
      Puzzle_Figure: Figure_Access;
      Is_Done: Boolean;
      Correct: Boolean;
   begin
      Socket := Init(Str.To_Unbounded_String("BestTeamEver"));
      Part_List := Receive_Parts(Socket);
      loop
       	 begin
	    Listen_Next(Socket, Puzzle_Figure, Is_Done);
	    exit when Is_Done;	    
	    Solve(Part_List, Puzzle_Figure); -- DUMMY
	    Send_Solution(Socket, Part_List, Puzzle_Figure);
	    Correct := Receive_Answer(Socket);
	 end;
      end loop;
      loop
	 Listen_End(Socket);
      end loop;
      --börja leta efter de sista meddelandena
   end Run;
   
   
end Runtime;
