with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body Figure is
   --|--------------------------------------------------------------------------
   --| Translate
   --| Takes:
   --| - Figure_Type : The figure to transform
   --| - DX, DY, DZ : The amount of steps to translate the figure
   --|--------------------------------------------------------------------------
   procedure Translate(Figure : in out Figure_Type; DX, DY, DZ : in Integer) is
   begin
      Figure.Pos(AXIS_X) := Figure.Pos(AXIS_X) + DX;
      Figure.Pos(AXIS_Y) := Figure.Pos(AXIS_Y) + DY;
      Figure.Pos(AXIS_Z) := Figure.Pos(AXIS_Z) + DZ;

      Figure.Steps(AXIS_X) := Figure.Steps(AXIS_X) + DX;
      Figure.Steps(AXIS_Y) := Figure.Steps(AXIS_Y) + DY;
      Figure.Steps(AXIS_Z) := Figure.Steps(AXIS_Z) + DZ;
   end Translate;

   --|--------------------------------------------------------------------------
   procedure Rotate(Figure : in out Figure_Type; Axis : in Axis_Enum;
                    Steps : in Integer := 1) is
   begin
      Figure.Shape.all := Rotate(Figure.Shape.all, Axis, Steps);
   end Rotate;

   --|--------------------------------------------------------------------------
   function Center(Figure : in Figure_Type) return Axis_Vector is
      T_Axis : Axis_Vector := Center(Figure.Shape.all);
   begin
      T_Axis(AXIS_X) := T_Axis(AXIS_X) + Figure.Pos(AXIS_X);
      T_Axis(AXIS_Y) := T_Axis(AXIS_Y) + Figure.Pos(AXIS_Y);
      T_Axis(AXIS_Z) := T_Axis(AXIS_Z) + Figure.Pos(AXIS_Z);
      return T_Axis;
   end Center;

   --|--------------------------------------------------------------------------
   function "=" (Left, Right : Figure_Type) return Boolean is
   begin
      return (Left.Id = Right.Id); -- Definitionsfråga, hur ska det fungera? bra fråga.
   end "=";

   --|--------------------------------------------------------------------------
   procedure Difference(Source: in out Figure_Type; Subtractor : Figure_Type) is
      T_Shape1 : Shape_Matrix := Shapeify(Source, Subtractor);
      T_Shape2 : Shape_Matrix := Shapeify(Subtractor, Source);
      V : Axis_Vector := (0, 0, 0);
   begin
      Source.Shape := Rotate(T_Shape1 - T_Shape2, V);
   end Difference;

   --|--------------------------------------------------------------------------
   procedure Union(Figure1: in out Figure_Type; Figure2 : Figure_Type) is
      T_Shape1 : Shape_Matrix := Shapeify(Figure1, Figure2);
      T_Shape2 : Shape_Matrix := Shapeify(Figure2, Figure1);
      V : Axis_Vector := (0, 0, 0);
   begin

      Figure1.Shape := Rotate(T_Shape1 + T_Shape2, V);
   end Union;
   

   --|--------------------------------------------------------------------------
   --function Contains(Figure1, Figure2 : Figure_Type) return Boolean is
   --begin
   --   return True; --TODO
   --end Contains;

   --function Intersect(Figure : in Figure_Type) return Shape_Matrix is
   --begin
      
   --end Intersect;

   --|--------------------------------------------------------------------------
   function Volume(Figure : in Figure_Type) return Integer is
   begin
      return Volume(Figure.Shape.all);
   end Volume;

   --|--------------------------------------------------------------------------
   function Overlaps(Figure1, Figure2 : in Figure_Type) return Boolean is
      T_Shape1 : Shape_Matrix := Shapeify(Figure1, Figure2);
      T_Shape2 : Shape_Matrix := Shapeify(Figure2, Figure1);
   begin
      return Overlaps(T_Shape1, T_Shape2);
   end Overlaps;

   --|--------------------------------------------------------------------------
   function Fits(Figure1, Figure2 : in Figure_Type) return Boolean is
      T_Shape1 : Shape_Matrix := Shapeify(Figure1, Figure2);
      T_Shape2 : Shape_Matrix := Shapeify(Figure2, Figure1);
   begin
      return Fits(T_Shape1, T_Shape2) or Fits(T_Shape2, T_Shape1); --or Fits(Figure2.Shape, Figure1.Shape);
   end Fits;

   --|--------------------------------------------------------------------------
   function Shapeify(Source, Relative : in Figure_Type) return Shape_Matrix is
      Max_X : Integer := Integer'Max(Size(Source.Shape.all, AXIS_X) + Source.Pos(AXIS_X),
                             Size(Relative.Shape.all, AXIS_X) + Relative.Pos(AXIS_X));
      Max_Y : Integer := Integer'Max(Size(Source.Shape.all, AXIS_Y) + Source.Pos(AXIS_Y),
                             Size(Relative.Shape.all, AXIS_Y) + Relative.Pos(AXIS_Y));
      Max_Z : Integer := Integer'Max(Size(Source.Shape.all, AXIS_Z) + Source.Pos(AXIS_Z),
                             Size(Relative.Shape.all, AXIS_Z) + Relative.Pos(AXIS_Z));

      Size_Vector : Axis_Vector;
   begin
      Size_Vector(AXIS_X) := Max_X;
      Size_Vector(AXIS_Y) := Max_Y;
      Size_Vector(AXIS_Z) := Max_Z;
--      Put("Id: ");
--      Put(Source.Id, 0);
--      New_Line;
--      Put("Last: ");
--      Put(Source.Shape'Last(1), 0);
--      Put(" ");
--      Put(Source.Shape'Last(2), 0);
--      Put(" ");
--      Put(Source.Shape'Last(3), 0);
--      New_Line;
--      Put("First: ");
--      Put(Source.Shape'First(1), 0);
--      Put(" ");
--      Put(Source.Shape'First(2), 0);
--      Put(" ");
--      Put(Source.Shape'First(3), 0);      
--      New_Line;
      return Standardize(Source.Shape.all, Size_Vector, Source.Pos);
   end Shapeify;

   function New_Figure(Shape : in Shape_Matrix; 
		       Id : in Integer := 0) return Figure_Access is
      T_Figure : Figure_Access := new Figure_Type;
   begin
      T_Figure.id := Id;
      Preload_Rotations(T_Figure.all, Shape);
      T_Figure.Shape := T_Figure.Rotation_List(1).Shape;
      return T_Figure;
   end New_Figure;

   --|--------------------------------------------------------------------------
   function Shape_To_Figure(Shape : in Shape_Matrix) return Figure_Access is
      --T_Figure : Figure_Type(Size(Shape, AXIS_X), Size(Shape, AXIS_Y), Size(Shape, AXIS_Z));
      Offset : Axis_Vector := (999, 999, 999);
      Size : Axis_Vector := (0, 0, 0);
   begin
      for X in Integer range Shape'Range(1) loop
         for Y in Integer range Shape'Range(2) loop
            for Z in Integer range Shape'Range(3) loop
               -- X
               if Shape(X, Y, Z) and Z < Offset(AXIS_Z) then
                  Offset(AXIS_Z) := Z;
               elsif not Shape(X, Y, Z) and Z > Size(AXIS_Z) then
                  Size(AXIS_Z) := Z;
               end if;
               -- Y
               if Shape(X, Y, Z) and Y < Offset(AXIS_Y) then
                  Offset(AXIS_Y) := Y;
               elsif not Shape(X, Y, Z) and Y > Size(AXIS_Y) then
                  Size(AXIS_Y) := Y;
               end if;
               -- Z
               if Shape(X, Y, Z) and X < Offset(AXIS_X) then
                  Offset(AXIS_X) := X;
               elsif not Shape(X, Y, Z) and X > Size(AXIS_X) then
                  Size(AXIS_X) := X;
               end if;
            end loop;
         end loop;
      end loop;

      Size(AXIS_X) := Size(AXIS_X) - Offset(AXIS_X) + 1;
      Size(AXIS_Y) := Size(AXIS_Y) - Offset(AXIS_Y) + 1;
      Size(AXIS_Z) := Size(AXIS_Z) - Offset(AXIS_Z) + 1;

      return New_Figure(Subshape(Shape, Size, Offset));
   end Shape_To_Figure;
   

   function Get_Rotation(R_Figure: in Figure_Access; Axis: in Axis_Enum) return Integer is  
   begin
      return R_Figure.Rotation_List(R_Figure.Rotation_Id).Rotation(Axis);
   end Get_Rotation;
   
   function Get_Rotation(R_Figure: in Figure_Access) return Integer is
   begin
      return R_Figure.Rotation_Id;
   end Get_Rotation;
   
   procedure Set_Rotation(Figure: in out Figure_Access; Rotation : in Integer) is
   begin
      Figure.Rotation_Id := Rotation;
      Figure.Shape := Figure.Rotation_List(Rotation).Shape;
   end Set_Rotation;
   
   function Get_Id(Figure: in Figure_Access) return Integer is
   begin
      return Figure.Id;
   end Get_Id;   
   
   function Get_X(Figure : Figure_Access) return Integer is
   begin
      return Figure.Pos(AXIS_X);
   end Get_X;
   
   function Get_Y(Figure : Figure_Access) return Integer is
   begin
      return Figure.Pos(AXIS_Y);
   end Get_Y;
   
   function Get_Z(Figure : Figure_Access) return Integer is
   begin
      return Figure.Pos(AXIS_Z);
   end Get_Z;
   
   function Get_Width(Figure : Figure_Access) return Integer is
   begin
      return Figure.Shape'Length(1);
   end Get_Width;
   
   function Get_Height(Figure : Figure_Access) return Integer is
   begin
      return Figure.Shape'Length(2);
   end Get_Height;
   
   function Get_Depth(Figure : Figure_Access) return Integer is
   begin
      return Figure.Shape'Length(3);
   end Get_Depth;
   
   
   procedure Set_Position(Figure : in out Figure_Access; X, Y, Z : in Integer) is
   begin
      Figure.Pos(AXIS_X) := X;
      Figure.Pos(AXIS_Y) := Y;
      Figure.Pos(AXIS_Z) := Z;
   end Set_Position;
   
   --|---------------------------------------------------------------------------
   procedure Preload_Rotations(Figure : in out Figure_Type; Shape : in Shape_Matrix) is
      -- T_Shape : aliased Shape_Matrix;
      X : Integer := 0;
      Y : Integer := 0;
      Z : Integer := 0;
      Vector : Axis_Vector;
      Rotate_Temp : Shape_Access;
   begin
      for I in Integer range Figure.Rotation_List'Range loop
	 Vector := (X, Y, Z);
	 -- T_Shape := Rotate(Shape, Figure.Rotation_List(I).Rotation);
	 Rotate_Temp := Rotate(Shape, Vector);
	 Figure.Rotation_List(I) := New_Rotation(Rotate_Temp, Vector); 
	 --Might have to change to return a pointer instead 
	 X := X + 1;
	 if X = 4 then
	    X := 0;
	    Y := Y + 1;
	    if Y = 3 then
	       Y := 0;
	       Z := Z + 1;
	    end if;
	 end if;
      end loop;
   end Preload_Rotations;
   
   function New_Rotation(Shape : Shape_Access; Vector : Axis_Vector) return Rotation_Type is
      Rotation : Rotation_Type := (Shape, Vector);
   begin
      --Put("I NEW_ROTATION: --------------------");
      --New_Line;
      --Put("Last: ");
      --Put(Shape'Last(1), 0);
      --Put(" ");
      --Put(Shape'Last(2), 0);
      --Put(" ");
      --Put(Shape'Last(3), 0);
      --New_Line;
      --Put("First: ");
      --Put(Shape'First(1), 0);
      --Put(" ");
      --Put(Shape'First(2), 0);
      --Put(" ");
      --Put(Shape'First(3), 0);      
      --New_Line;      
      return Rotation;
   end New_Rotation;
   
   procedure Put(Figure : Figure_Access) is
   begin
      Put(Figure.Shape.all);
   end Put;
   
   
end Figure;
