with Figure; use Figure;
with Figure_List; use Figure_List;

package Algorithm is
   
   procedure Solve(Part_List : in out Figure_List_Type; Figure : in Figure_Access; Solved : out Boolean);
   procedure Optimize(Part_List : in out Figure_List_Type);
   
end Algorithm;
