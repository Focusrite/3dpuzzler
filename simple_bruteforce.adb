with Figure; use Figure;
with Figure_List; use Figure_List;
with Ada.Text_IO; use Ada.Text_IO;
procedure Simple_Bruteforce(Part_List : in out Figure_List_Type; Figure : in Figure_Type) is 
	Current_Part : Figure_Access;
	Goal : Figure_Type := Figure;
begin
	First(Part_List, Current_Part);
	while Volume(Figure) > 0 loop
		if Get_Z(Current_Part) + Get_Depth(Current_Part) > Get_Depth(Goal) then
			if Get_Id(Current_Part) = 1 then
				Put("FAKKING GÅR INTE");
				exit;
			else 
			   Set_Position(Current_Part, 0, 0, 0);
			   Set_Rotation(Current_Part, 1);
				Previous(Part_List, Current_Part); -- BEHÖVER IMPLEMENTERA DENNA FUNKTION
				Goal := Union(Goal, Current_Part);
			end if;
		else
			if Get_Y(Current_Part) + Get_Height(Current_Part) > Get_Height(Goal) then
			   Set_Position(Current_Part, 0, 0, Get_Z(Current_Part) + 1);
			else
				if Get_X(Current_Part) + Get_Width(Current_Part) > Get_Width(Goal) then
					Set_Position(Current_Part, 0, Get_Y(Current_Part) + 1, Get_Z(Current_Part))
				else
					if Fits(Current_Part, Goal) then
						Goal := Difference(Goal, Current_Part);
						Next(Figure_List_Type, Current_Part);
						if  Current_Part = null then
						   Put("Slut på delar");
						   exit;
						end if;
						
					else
						if Get_Rotation(Current_Part) >= 24 then
							Set_Rotation(Current_Part, 1);
							Set_Position(Current_Part, Get_X(Current_Part) + 1, Get_Y(Current_Part), Get_Z(Current_Part));
						else
							Set_Rotation(Current_Part, Get_Rotation(Current_Part) + 1);
						end if;
					end if;
				end if;
			end if;
		end if;
	end loop;
end Simple_Bruteforce;
