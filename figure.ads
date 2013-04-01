--|-------------------------------------------------------------------------------------------
--| Tobias Hultqvist tobhu543, Ludvig En luden963,
--| Viktor Ringdahl vikri500,  Sebastian Parmbäck sebpa096
--|
--| The figure package contains the type Figure_Type, aswell as functions related to it.
--| The Figure_Type consists of a Shape, its position, aswell as its steps and rotations made.
--| A Figure is both the type of the target figure, and the pieces given to build it with.
--|
--| The functions and procedures handles and manipulates the geometric part of Figures,
--| aswell as interactions betweem figures.
--|-------------------------------------------------------------------------------------------
with Geometry; use Geometry;

package Figure is
   type Figure_Type(<>) is private;

   procedure Translate(Figure : in out Figure_Type; DX, DY, DZ : in Integer);
   procedure Rotate(Figure : in out Figure_Type; Axis : in Axis_Enum;
                    Steps : in Integer := 1);

   function Center(Figure : in Figure_Type) return Axis_Vector;
   function "=" (Left, Right : Figure_Type) return Boolean;

   function Difference(Source, Subtractor : Figure_Type) return Figure_Type;

   function Union(Figure1, Figure2 : Figure_Type) return Figure_Type;

   function Contains(Figure1, Figure2 : Figure_Type) return Boolean;

   function Intersect(Figure : in Figure_Type) return Shape_Type;
   function Volume(Figure : in Figure_Type) return Integer;

   function Overlaps(Figure1, Figure2 : in Figure_Type) return Boolean;
   function Fits(Figure1, Figure2 : in Figure_Type) return Boolean;

   function Equalize(Figure1, Figure2 : in Figure_Type) return Figure_Type;

   function Shape_To_Figure(Shape : in Shape_Type) return Figure_Type;

   function New_Figure(Xt, Xy, Zt : in Integer) return Figure_Type;

private
   type Figure_Type(Xt, Yt, Zt : Integer) is
      record
	 Pos : Axis_Vector := (0, 0, 0);
	 Shape : Shape_Matrix(1..Xt, 1..Yt, 1..Zt);
	 Steps : Axis_Vector := (0, 0, 0);
         Rotations: Axis_Vector := (0, 0, 0);
         Id : Integer := 0;
	 -- fill
      end record;

end Figure;
