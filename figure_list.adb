with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Containers; use Ada.Containers;


package body Figure_List is
   procedure Append(List : in out Figure_List_Type; Figure : Figure_Access) is
   begin
      Figures.Append(List.L, Figure);
      --Put("I append: ----------------");
      --Put("Size:");
      --New_Line;
      --Put("Width: ");
      --Put(Get_Width(Figure), 0);
      --New_Line;
      --Put("Height: ");
      --Put(Get_Height(Figure), 0);
      --New_Line;
      --Put("Depth: ");
      --Put(Get_Depth(Figure), 0);
      New_Line;      

   end Append;
   
   procedure Remove(List : in out Figure_List_Type; Figure : Figure_Access) is
   begin
      --Figures.Delete(List.L, Figures.Find(List.L, Figure));
      return;
   end Remove;
   
   procedure Insert(List : in out Figure_List_Type; Position : Integer; Figure : Figure_Type)is
   begin
      return;
   end Insert;
   
   function Member(List : Figure_List_Type; Figure : Figure_Type) return Boolean is
   begin
      return True;
   end Member;
   
   procedure Clear(List : in out Figure_List_Type) is
   begin
      Figures.Clear(List.L);
   end Clear;
     
   procedure First(List: in out Figure_List_Type; F_Figure: out Figure_Access) is
   begin
      List.C := Figures.First(List.L);
      F_Figure := Figures.Element(List.C);
   end;
   
   procedure Next(List: in out Figure_List_Type; N_Figure: out Figure_Access) is
   begin
      List.C := Figures.Next(List.C);
      N_Figure := Figures.Element(List.C);
   end Next;
   
   procedure Previous(List: in out Figure_List_Type; N_Figure: out Figure_Access) is
   begin
      List.C := Figures.Previous(List.C);
      N_Figure := Figures.Element(List.C);
   end Previous;
   
   function Last_Element(List: Figure_List_Type) return Figure_Type is
   begin
      return Figures.Last_Element(List.L).all;
   end Last_Element;
   
   procedure Sort(List : in out Figure_List_Type) is
   begin
      Sorting.Sort(List.L);
   end Sort;
   
   function Length(List : in Figure_List_Type) return Integer is
   begin
      return Integer'Value(Count_Type'Image(Figures.Length(List.L)));
   end Length;
   
   
 --  procedure Iter_Put(List : in out Figure_List_Type) is
 --     procedure Put(Item : Figure_Access) is
 --     begin
--	 Put("Size:");
--	 New_Line;
--	 Put("Width: ");
--	 Put(Get_Width(Figure), 0);
--	 New_Line;
--	 Put("Height: ");
--	 Put(Get_Height(Figure), 0);
--	 New_Line;
--	 Put("Depth: ");
--	 Put(Get_Depth(Figure), 0);
--	 New_Line;
--      end Put;
--   begin
--      Iterate(List.L, Put(List.C));
--   end Iter_Put;
     
end Figure_List;

