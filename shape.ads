--|----------------------------------------------------------------------------------------
--| Tobias Hultqvist tobhu543, Ludvig En luden963,
--| Viktor Ringdahl vikri500,  Sebastian Parmbäck sebpa096
--|
--| The Shape package includes the Shape_Matrix, a three dimensional array of booleans,
--| representing a 3d-shape. A TRUE value represents a filled cell, while FALSE represents
--| an empty cell.
--|
--| It also includes functions that applies set theory, aswell as a few manipulative and 
--| geometric functions.
--| 
--| Additionally, there are two operators declared:
--|  = : The set theory's "equals"
--|  - : The set theory's "difference"
--|----------------------------------------------------------------------------------------

with Geometry; use Geometry;
with Ada.Unchecked_Deallocation;

package Shape is
   type Shape_Matrix is array(Integer range <>, Integer range <>, Integer range <>) of Boolean;
   type Shape_Access is access all Shape_Matrix;
   procedure Free_Vector is new Ada.Unchecked_Deallocation(Object => Shape_Matrix, Name => Shape_Access);

   function "=" (Left, Right : Shape_Matrix) return Boolean;
   function "-" (Left, Right : Shape_Matrix) return Shape_Matrix;
   function "+" (Left, Right : Shape_Matrix) return Shape_Matrix;

   function Rotate(Shape : Shape_Matrix; Axis : Axis_Enum; Steps : Integer := 1) return Shape_Matrix;
   function Rotate(Shape : Shape_Matrix; Rotations : Axis_Vector) return Shape_Access; 
   -- Rotations is a vector with amount of steps along the axis 
   function Overlaps(Shape1, Shape2 : Shape_Matrix) return Boolean;
   function Fits(Shape1, Shape2 : Shape_Matrix) return Boolean;

   function Inverse(Shape : Shape_Matrix) return Shape_Matrix;

   function Corner(Shape : Shape_Matrix) return Boolean;
   function Center(Shape : Shape_Matrix) return Axis_Vector;

   function Standardize(Shape : Shape_Matrix; Size, Offset : Axis_Vector) return Shape_Matrix;
   function Subshape(Shape : Shape_Matrix; Size, Offset : Axis_Vector) return Shape_Matrix;
   function Volume(Shape : Shape_Matrix) return Integer;
   function Size(Shape : Shape_Matrix; Axis : Axis_Enum) return Integer;
   
private
   
end Shape;
