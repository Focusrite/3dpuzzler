with Geometry; use Geometry;
with Shape;    use Shape;

package body Figure is
begin
   --|--------------------------------------------------------------------------
   --| Translate
   --| Takes:
   --|   - Figure_Type : The figure to transform
   --|   - DX, DY, DZ  : The amount of steps to translate the figure
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
      Rotate(Figure.Shape, Axis, Steps);
   end Rotate;

   --|--------------------------------------------------------------------------
   function Center(Figure : in Figure_Type) return Axis_Vector is
      T_Axis : Axis_Vector := Center(Figure.Shape);
   begin
      T_Axis(AXIS_X) := T_Axis(AXIS_X) + Figure.Pos(AXIS_X);
      T_Axis(AXIS_Y) := T_Axis(AXIS_Y) + Figure.Pos(AXIS_Y);
      T_Axis(AXIS_Z) := T_Axis(AXIS_Z) + Figure.Pos(AXIS_Z);
      return T_Axis;
   end Center;

   --|--------------------------------------------------------------------------
   function "=" (Left, Right : Figure_Type) return Boolean is
   begin
      return (Left.Id = Right.Id); -- Definitionsfr�ga, hur ska det fungera?
   end "=";

   --|--------------------------------------------------------------------------
   function Difference(Source, Subtractor : Figure_Type) return Figure_Type is
      T_Shape1 : Shape_Matrix := Shapeify(Figure1, Figure2);
      T_Shape2 : Shape_Matrix := Shapeify(Figure2, Figure1);
   begin

      return Shape_To_Figure(T_Shape1 - T_Shape2);
   end Difference;

   --|--------------------------------------------------------------------------
   function Union(Figure1, Figure2 : Figure_Type) return Figure_Type is
      T_Shape1 : Shape_Matrix := Shapeify(Figure1, Figure2);
      T_Shape2 : Shape_Matrix := Shapeify(Figure2, Figure1);
   begin

      return Shape_To_Figure(T_Shape1 + T_Shape2);
   end Union;

   --|--------------------------------------------------------------------------
   function Contains(Figure1, Figure2 : Figure_Type) return Boolean is
   begin

   end Contains;

   function Intersect(Figure : in Figure_Type) return Shape_Type is
      T_Shape1 : Shape_Matrix := Shapeify(Figure1, Figure2);
      T_Shape2 : Shape_Matrix := Shapeify(Figure2, Figure1);
   begin

      return Shape_To_Figure(Intersect(T_Shape1), Inverse(T_Shape2));
   end Intersect;

   --|--------------------------------------------------------------------------
   function Volume(Figure : in Figure_Type) return Integer is
   begin
      Volume(Figure.Shape);
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
   begin
      return Fits(Figure1.Shape, Figure2.Shape); --or Fits(Figure2.Shape, Figure1.Shape);
   end Fits;

   --|--------------------------------------------------------------------------
   function Shapeify(Source, Relative : in Figure_Type) return Shape_Type is
      Max_X : Integer := Max(Size(Source.Shape, AXIS_X) + Source.Pos(AXIS_X),
                             Size(Relative.Shape, AXIS_X) + Relative.Pos(AXIS_X));
      Max_Y : Integer := Max(Size(Source.Shape, AXIS_Y) + Source.Pos(AXIS_Y),
                             Size(Relative.Shape, AXIS_Y) + Relative.Pos(AXIS_Y));
      Max_Z : Integer := Max(Size(Source.Shape, AXIS_Z) + Source.Pos(AXIS_Z),
                             Size(Relative.Shape, AXIS_Z) + Relative.Pos(AXIS_Z));

      Size_Vector : Axis_Vector;
      T_Shape1    : Shape_Matrix;
   begin
      Size_Vector(AXIS_X) := Max_X;
      Size_Vector(AXIS_Y) := Max_Y;
      Size_Vector(AXIS_Z) := Max_Z;

      return Standardize(Source.Size, Size_Vector, Source.Pos);
   end Equalize;

   function New_Figure(Shape : in Shape_Matrix; Id : in Integer := 0) return Figure_Type is
      T_Figure : Figure(Size(Shape, AXIS_X), Size(Shape, AXIS_Y), Size(Shape, AXIS_Z));
   begin
      T_Figure.id := id;
      return T_Figure;
   end New_Figure;

   --|--------------------------------------------------------------------------
   function Shape_To_Figure(Shape : in Shape_Type) return Figure_Type is
      T_Figure : Figure;
      Offset : Axis_Vector := (999, 999, 999);
      Size : Axis_Vector := (0, 0, 0);
   begin
      for X in Integer range Shape'Range(1) loop
         for Y in Integer range Shape'Range(2) loop
            for Z in Integer range Shape'Range(3) loop
               -- X
               if Shape(X, Y, Z) and Z < Offset(AXIS_Z) then
                  Offset(AXIS_Z);
               elsif not Shape(X, Y, Z) and Z > Size(AXIS_Z)) then
                  Size(AXIS_Z) := Z;
               end if;
               -- Y
               if Shape(X, Y, Z) and Y < Offset(AXIS_Y) then
                  Offset(AXIS_Y);
               elsif not Shape(X, Y, Z) and Y > Size(AXIS_Y)) then
                  Size(AXIS_Y) := Y;
               end if;
               -- Z
               if Shape(X, Y, Z) and X < Offset(AXIS_X) then
                  Offset(AXIS_X);
               elsif not Shape(X, Y, Z) and X > Size(AXIS_X)) then
                  Size(AXIS_X) := X;
               end if;
            end loop;
         end loop;
      end loop;

      Size(AXIS_X) := Size(AXIS_X) - Offset(AXIS_X);
      Size(AXIS_Y) := Size(AXIS_Y) - Offset(AXIS_Y);
      Size(AXIS_Z) := Size(AXIS_Z) - Offset(AXIS_Z);

      return New_Figure(Subshape(Shape, Size, Offset));
   end Shape_To_Figure;

end Figure;