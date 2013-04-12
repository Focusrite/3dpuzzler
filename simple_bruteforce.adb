with Figure; use Figure;
with Figure_List; use Figure_List;
with Ada.Text_IO; use Ada.Text_IO;
procedure Simple_Bruteforce(Part_List : in out Figure_List_Type; Figure : in Figure_Type) is 
	Current_Part : Figure_Access;
	Goal : Figure_Type := Figure;
begin
	First(Part_List, Current_Part);
	while Volume(Figure) > 0 loop
		if Current_Part.Z + Current_Part.Shape(3)'Last > Goal.Shape(3)'Last then
			if Get_Id(Current_Part) = 1 then
				Put("FAKKING GÅR INTE");
				break;
			else 
				Previous(List, Current_Part); -- BEHÖVER IMPLEMENTERA DENNA FUNKTION
				Goal := Union(Goal, Current_Part);
			end if;
		else
			if Current_Part.Y + Current_Part.Shape(2)'Last > Goal.Shape(2)'Last then
				Current_Part.X := 0;
				Current_Part.Y := 0;
				Current_Part.Z := Current_Part.Z + 1;
			else
				if Current_Part.X + Current_Part.Shape(1)'Last > Goal.Shape(1)'Last then
					Current_Part.X := 0;
					Current_Part.Y := Current_Part.Y + 1;
				else
					if Fits(Current_Part, Goal) then
						Goal := Difference(Goal, Current_Part);
						Next(Figure_List_Type, Current_Part);
						-- BEHÖVER KOLLA OM VI GÅTT RUNT HELA LISTA, VI FÅR -INTE- KOMMA TILLBAKA TILL ELEMENT 1
					else
						if Get_Rotation(Current_Part) >= 24 then
							Current_Part.Shape := Current_Part.Rotations_Array(1);
							Current_Part.Rotation_Id := 1;
							Current_Part.X := Current_Part.X + 1;
						else
							Current_Part.Shape := Current_Part.Rotations_Array(Get_Rotation(Current_Part) + 1);
							Current_Part.Rotation_Id := Get_Rotation(Current_Part) + 1;
						end if;
					end if;
				end if;
			end if;
		end if;
	end loop;
end Simple_Bruteforce;