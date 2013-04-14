with Figure; use Figure;
with Figure_List; use Figure_List;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body Algorithm is
   
   procedure Solve(Part_List : in out Figure_List_Type; Figure : in Figure_Access) is
      Current_Part : Figure_Access;
      Goal : Figure_Access := new Figure_Type;
   begin
      Goal.all := Figure.all;
      First(Part_List, Current_Part);
      while Volume(Goal.all) > 0 loop
	 Put("Volume: "); Put(Volume(Goal.all), 0); New_Line;
	 Put("Using Part ID: "); Put(Get_Id(Current_Part), 0); New_Line;
	 if Current_Part = NULL then
	    Put("Inga bitar kvar.");
	    exit;
	 end if;
	 if Get_Z(Current_Part) + Get_Depth(Current_Part) > Get_Depth(Goal) then
	    Put_Line("Går tillbaka i lista, ej plats.");
	    Set_Position(Current_Part, 0, 0, 0);
	    Set_Rotation(Current_Part, 1);
	    Previous(Part_List, Current_Part); 
	    Union(Goal.all, Current_Part.all);
	 else
	    if Get_Y(Current_Part) + Get_Height(Current_Part) > Get_Height(Goal) then
	       Put_Line("Testar nästa lager.");
	       Set_Position(Current_Part, 0, 0, Get_Z(Current_Part) + 1);
	    else
	       if Get_X(Current_Part) + Get_Width(Current_Part) > Get_Width(Goal) then
		  Put_Line("Testar nästa nivå.");
		  Set_Position(Current_Part, 0, Get_Y(Current_Part) + 1, Get_Z(Current_Part));
	       else
		  if Fits(Current_Part.all, Goal.all) then
		     Put_Line("Placerar in en bit.");
		     Put("Volume innan difference");
		     Put(Volume(Goal.all), 0);
		     New_Line;
		     Difference(Goal.all, Current_Part.all);
		     Next(Part_List, Current_Part);
		     if  Current_Part = null then
			Put_Line("Slut på delar");
			exit;
		     end if;
		     
		  else
		     Put_Line("Rotations skit.");
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
