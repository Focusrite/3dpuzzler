--|----------------------------------------------------------------------------------------
--| Tobias Hultqvist tobhu543, Ludvig En luden963,
--| Viktor Ringdahl vikri500,  Sebastian Parmbäck sebpa096
--|
--| The Figure_List package contains the Figure_List_Type, a double linked list containing
--| multiple Figures.
--| We might change this into a list type we've written ourselves.
--|
--| It also conatins a few functions and procedures manipulating these lists.
--|
--|----------------------------------------------------------------------------------------

with Ada.Containers.Doubly_Linked_Lists;
with Figure; use Figure;

package Figure_List is 
   package Figures is new Ada.Containers.Doubly_Linked_Lists(Figure_Type);
   -- use Figures;
   
   type Figure_List_Type is private;
   
   procedure Append(List : Figure_List_Type; Figure : Figure_Type);
   procedure Remove(List : Figure_List_Type; Figure : Figure_Type);
   procedure Insert(List : Figure_List_Type; Position : Integer; Figure : Figure_Type);
   function Member(List : Figure_List_Type; Figure : Figure_Type) return Boolean;
   
private
   
   subtype Figure_List_Type is Figures.List;
   
end Figure_List;
