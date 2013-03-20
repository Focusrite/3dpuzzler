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
   
   procedure Transform(Figure : in out Figure_Type; DX, DY, DZ : in Integer);
   procedure Rotate(Figure : in out Figure_Type; Axis : in Axis_Enum; Steps : in Integer);
   
   function Center(Figure : in Figure_Type) return Axis_Vector;
   function "=" (Left, Right : Figure_Type) return Boolean;
   
   function Difference(Source, Subtractor) return Figure_Type;
   
   function Union(Figure1, Figure2 : Figure_Type) return Figure_Type;
   
   function Contains(Figure1, Figure2 : Figure_Type) return Boolean;
   
   function Intersect(Figure : in Figure_Type) return Shape_Type;
   function Volume(Figure : in Figure_Type) return Integer;
   
   function Overlaps(Figure1, Figure2 : in Figure_Type) return Boolean;
   function Fits(Figure1, Figure2 : in Figure_Type) return Boolean;
   
private
   type Figure_Type(Xt, Yt, Zt : Integer) is
      record
	 X, Y, Z : Integer;
	 Shape : Bool_Matrix(1..Xt, 1..Yt, 1..Zt);
	 Steps : Axis_Vector;
	 Rotations: Axis_Vector;
	 -- fill
      end record;
   
end Figure;
