

package body Figure_List is
   procedure Append(List : in out Figure_List_Type; Figure : Figure_Access) is
   begin
      Figures.Append(List.L, Figure);
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
     
   procedure First(List: in out FIgure_List_Type; F_Figure: out Figure_Access) is
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
   
     
     
end Figure_List;

