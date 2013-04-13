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
with Shape;    use Shape;
with Geometry; use Geometry;

package Figure is
   type Figure_Type is private; --(<>)
   type Rotation_Type is private;
   type Rotations_Array is array (Integer range 1..24) of Rotation_Type;
   type Figure_Access is access all Figure_Type;
   
   procedure Translate(Figure : in out Figure_Type; DX, DY, DZ : in Integer);
   procedure Rotate(Figure : in out Figure_Type; Axis : in Axis_Enum;
                    Steps : in Integer := 1);

   function Center(Figure : in Figure_Type) return Axis_Vector;
   function "=" (Left, Right : Figure_Type) return Boolean;

   function Difference(Source, Subtractor : Figure_Type) return Figure_Access;

   function Union(Figure1, Figure2 : Figure_Type) return Figure_Access;

   --function Contains(Figure1, Figure2 : Figure_Type) return Boolean;

   --function Intersect(Figure : in Figure_Type) return Shape_Matrix;
   function Volume(Figure : in Figure_Type) return Integer;

   function Overlaps(Figure1, Figure2 : in Figure_Type) return Boolean;
   function Fits(Figure1, Figure2 : in Figure_Type) return Boolean;

   function Shapeify(Source, Relative : in Figure_Type) return Shape_Matrix;

   function Shape_To_Figure(Shape : in Shape_Matrix) return Figure_Access;

   function New_Figure(Shape : in Shape_Matrix; Id : in Integer := 0) return Figure_Access;
   
   function Get_Rotation(R_Figure: Figure_Type; Axis: Axis_Enum) return Integer;
   
   function Get_Id(Figure: Figure_Access) return Integer;
   
   procedure Preload_Rotations(Figure : in out Figure_Type; Shape : in Shape_Matrix);
   
   function New_Rotation(Shape : Shape_Access; Vector : Axis_Vector) return Rotation_Type;
private
   type Figure_Type is
      record
	 Pos : Axis_Vector := (0, 0, 0);
	 Shape : Shape_Access; --Current
	 Rotation_List : Rotations_Array;
	 Steps : Axis_Vector := (0, 0, 0);
         Rotation_Id: Integer := 1;
         Id : Integer := 0;
	 -- fill
      end record;
   
   type Rotation_Type is
      record
	 Shape : Shape_Access;
	 Rotation : Axis_Vector := (0, 0, 0);
      end record;	 

end Figure;
