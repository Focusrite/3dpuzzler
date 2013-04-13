with Figure; use Figure;
with Figure_List; use Figure_List;
with Ada.Text_IO; use Ada.Text_IO;

package body Algorithm is
   
   procedure Solve(Part_List : in out Figure_List_Type; Figure : in Figure_Access) is
      Current_Part : Figure_Access;
      Goal : Figure_Access := new Figure_Type;
   begin
      Goal.all := Figure.all;
      First(Part_List, Current_Part);
      while Volume(Goal.all) > 0 loop
	 if Get_Z(Current_Part) + Get_Depth(Current_Part) > Get_Depth(Goal) then
	    if Get_Id(Current_Part) = 1 then
	       Put("FAKKING GÅR INTE");
	       exit;
	    else 
	       Set_Position(Current_Part, 0, 0, 0);
	       Set_Rotation(Current_Part, 1);
	       Previous(Part_List, Current_Part); -- BEHÖVER IMPLEMENTERA DENNA FUNKTION
	       Goal := Union(Goal.all, Current_Part.all);
	    end if;
	 else
	    if Get_Y(Current_Part) + Get_Height(Current_Part) > Get_Height(Goal) then
	       Set_Position(Current_Part, 0, 0, Get_Z(Current_Part) + 1);
	    else
	       if Get_X(Current_Part) + Get_Width(Current_Part) > Get_Width(Goal) then
		  Set_Position(Current_Part, 0, Get_Y(Current_Part) + 1, Get_Z(Current_Part));
	       else
		    if Fits(Current_Part.all, Goal.all) then
		       Goal := Difference(Goal.all, Current_Part.all);
		       Next(Part_List, Current_Part);
		       if  Current_Part = null then
			  Put("Slut på delar");
			  exit;
		       end if;
		       
		    else
		       if Get_Rotation(Current_Part) >= 24 then
			  Set_Rotation(Current_Part, 1);
			  Set_Position(Current_Part, Get_X(Current_Part) + 1,
				       Get_Y(Current_Part),
				       Get_Z(Current_Part));
		       else
			  Set_Rotation(Current_Part, Get_Rotation(Current_Part) + 1);
		       end if;
		    end if;
	       end if;
	    end if;
	 end if;
      end loop;
   end Solve;

   
end Algorithm;
