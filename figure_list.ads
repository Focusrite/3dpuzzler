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
   package Figures is new Ada.Containers.Doubly_Linked_Lists(Figure_Access);
   -- use Figures;
   
   --Figure_List_Type : renames Figures.List;
   type Figure_List_Type is private;
   
   
   
   procedure Append(List : in out Figure_List_Type; Figure : Figure_Access);
   procedure Remove(List : in out Figure_List_Type; Figure : Figure_Access);
   procedure Insert(List : in out Figure_List_Type; Position : Integer; Figure : Figure_Type);
   procedure First(List: in out Figure_List_Type; F_Figure: out Figure_Access);
   function  Member(List : in Figure_List_Type; Figure : Figure_Type) return Boolean;
   function Last_Element(List : in Figure_List_Type) return Figure_Type;
   procedure Next(List: in out Figure_List_Type; N_Figure: out Figure_Access);
   procedure Previous(List : in out Figure_List_Type; N_Figure : out Figure_Access);
   
private
   
   
   type Figure_List_Type is
      record
	 L : Figures.List;
	 C : Figures.Cursor;
      end record;
   
end Figure_List;
 
