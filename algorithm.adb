with Figure; use Figure;
with Figure_List; use Figure_List;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body Algorithm is
   
   procedure Solve(Part_List : in out Figure_List_Type; Figure : in Figure_Access; Solved : out Boolean) is
      Current_Part : Figure_Access;
      Goal : Figure_Access := new Figure_Type;
      Backed : Boolean := False;
      Rotations_Left : Boolean := True;
   begin
      Goal.all := Figure.all;
      First(Part_List, Current_Part);
      while Volume(Goal.all) > 0 loop
	 --Put("Using Part ID: "); Put(Get_Id(Current_Part), 0); Put(", på plats: ");Put("X: "); Put(Get_X(Current_Part), 0); Put(", Y: "); Put(Get_Y(Current_Part), 0); Put(", Z: "); Put(Get_Z(Current_Part), 0); Put(", R: "); Put(Get_Rotation(Current_Part), 0); Put(", pWidth: "); Put(Get_Width(Current_Part), 0); Put(", gWidth: "); Put(Get_Width(Goal), 0);New_Line;
	 if Get_Z(Current_Part) + Get_Depth(Current_Part) - 1 > Get_Depth(Goal) and not Rotations_Left then
	    Set_Position(Current_Part, 0, 0, 0);
	    Set_Rotation(Current_Part, 1);
	    begin
	       Previous(Part_List, Current_Part); 
	    exception
	       when others =>
		  Solved := False;
		  return;
	    end;
	    Union(Goal.all, Current_Part.all);
	    Backed := True;
	    Rotations_Left := True;
	 else
	    if Get_Y(Current_Part) + Get_Height(Current_Part) - 1 > Get_Height(Goal) and not Rotations_Left then
	       Set_Position(Current_Part, 0, 0, Get_Z(Current_Part) + 1);
	    else
	       if Get_X(Current_Part) + Get_Width(Current_Part) - 1 > Get_Width(Goal) and not Rotations_Left then
		  Set_Position(Current_Part, 0, Get_Y(Current_Part) + 1, Get_Z(Current_Part));
	       else
		  if not Backed and Fits(Current_Part.all, Goal.all) then
		     Difference(Goal.all, Current_Part.all);
		     begin
			Next(Part_List, Current_Part);
		     exception
			when others =>
			   Solved := True;
			   return;
		     end;
		     Backed := False;
		     Rotations_Left := True;
		  else
		     
		     if Get_Rotation(Current_Part) >= 24 then
			Rotations_Left := False;
			Set_Rotation(Current_Part, 1);
			Set_Position(Current_Part, Get_X(Current_Part) + 1,
				     Get_Y(Current_Part),
				     Get_Z(Current_Part));
		     else
			Rotations_Left := True;
			Set_Rotation(Current_Part, Get_Rotation(Current_Part) + 1);
		     end if;
		  end if;
	       end if;
	    end if;
	    Backed := False;
	 end if;
      end loop;
      Solved := True;
   end Solve;
   
   procedure Optimize(Part_List : in out Figure_List_Type) is
   begin
      Sort(Part_List);
   end Optimize;

   
end Algorithm;
