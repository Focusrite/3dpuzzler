

package body Figure_List is
   procedure Append(List : Figure_List_Type; Figure : Figure_Type)is
   begin
      return;
   end Append;
   procedure Remove(List : Figure_List_Type; Figure : Figure_Type)is
   begin
      return;
   end Remove;
   procedure Insert(List : Figure_List_Type; Position : Integer; Figure : Figure_Type)is
   begin
      return;
   end Insert;
   function Member(List : Figure_List_Type; Figure : Figure_Type) return Boolean is
   begin
      return True;
   end Member;
     
   function First(List : in out Figure_List_Type) return Figure_Access is
   begin
      List.C := Figures.First(List.L);
      return Figures.Element(List.C);
   end;
   
   function Next(List: in out Figure_List_Type) return Figure_Access is
   begin
      List.C := Figures.Next(List.C);
      return Figures.Element(List.C);
   end Next;
   
   function Last_Element(List: Figure_List_Type) return Figure_Type is
   begin
      return Figures.Last_Element(List.L).all;
   end Last_Element;
   
     
     
end Figure_List;

