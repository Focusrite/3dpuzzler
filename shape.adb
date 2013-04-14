with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

--TODO: ROTERA FLERA GGR IRAD!!!
package body Shape is
   function "=" (Left, Right : Shape_Matrix)
		return Boolean is
   begin
      if Left'Last(1) /= Right'Last(1) or Left'Last(2) /= Right'Last(2) or Left'Last(3) /= Right'Last(3) then
	 return False;
      end if;
      for X in Left'Range(1) loop
	 for Y in Left'Range(2) loop
	    for Z in Left'Range(3) loop
	       if Left(X, Y, Z) /= Right(X, Y, Z) then
		  return False;
	       end if;
	    end loop;
	 end loop;
      end loop;
      return True;
   end "=";
   
   
   
   function "-" (Left, Right : Shape_Matrix)
		return Shape_Matrix is
      New_Shape : Shape_Matrix(Left'Range(1), Left'Range(2), Left'Range(3));
   begin
      for X in Left'Range(1) loop
	 for Y in Left'Range(2) loop
	    for Z in Left'Range(3) loop
	       New_Shape(X, Y, Z) := (Left(X, Y, Z) and not Right(X, Y, Z));
	    end loop;
	 end loop;
      end loop;
      return New_Shape;
   end "-";
   
   function "+" (Left, Right : Shape_Matrix)
		return Shape_Matrix is
      function Union_Brain(Left, Right : Shape_Matrix; X, Y, Z : Integer)
			  return Shape_Matrix is
	 Temp : Shape_Matrix(1..X, 1..Y, 1..Z);
      begin
	 for Xi in Temp'Range(1) loop
	    for Yi in Temp'Range(2) loop
	       for Zi in Temp'Range(3) loop
		  if Xi in Left'Range(1) and Yi in Left'Range(2) and Zi in Left'Range(3) then
		     Temp(Xi, Yi, Zi) := Left(Xi, Yi, Zi);
		  else
		     Temp(Xi, Yi, Zi) := False;
		  end if;
		  if Xi in Right'Range(1) and Yi in Right'Range(2) and Zi in Right'Range(3) then
		     Temp(Xi, Yi, Zi) := Temp(Xi, Yi, Zi) or Right(Xi, Yi, Zi);
		  else
		     Temp(Xi, Yi, Zi) := Temp(Xi, Yi, Zi) or False;
		  end if;
	       end loop;
	    end loop;
	 end loop;
	 return Temp;
      end Union_Brain;
   begin
      return Union_Brain(Left, Right,
			 Integer'Max(Left'Last(1), Right'Last(1)), 
			 Integer'Max(Left'Last(2), Right'Last(2)), 
			 Integer'Max(Left'Last(3), Right'Last(3)));
   end "+";
   
   function Rotate(Shape : Shape_Matrix; Axis : Axis_Enum; Steps : Integer := 1)
		  return Shape_Matrix is
      function Rotate_X(Shape : Shape_Matrix)
		       return Shape_Matrix is
	 New_Shape : Shape_Matrix(Shape'Range(1), Shape'Range(3), Shape'Range(2));
      begin
	 for Z in Shape'Range(3) loop
	    for Y in Shape'Range(2) loop
	       for X in Shape'Range(1) loop
		  New_Shape(X, Z, (New_Shape'Last(3) - Y + 1)) := Shape(X, Y, Z);
	       end loop;
	    end loop;
	 end loop;
	 return New_Shape;
      end Rotate_X;

      function Rotate_Y(Shape : Shape_Matrix)
		       return Shape_Matrix is
	 New_Shape : Shape_Matrix(Shape'Range(3), Shape'Range(2), Shape'Range(1));
      begin
	 for Z in Shape'Range(3) loop
	    for Y in Shape'Range(2) loop
	       for X in Shape'Range(1) loop
		  New_Shape((New_Shape'Last(1) - Z + 1), Y, X) := Shape(X, Y, Z);
	       end loop;
	    end loop;
	 end loop;
	 return New_Shape;
      end Rotate_Y;
      function Rotate_Z(Shape : Shape_Matrix)
		       return Shape_Matrix is
	 New_Shape : Shape_Matrix(Shape'Range(2), Shape'Range(1), Shape'Range(3));
      begin
	 for Z in Shape'Range(3) loop
	    for Y in Shape'Range(2) loop
	       for X in Shape'Range(1) loop
		  New_Shape(Y, (New_Shape'Last(2) - X + 1), Z) := Shape(X, Y, Z);
	       end loop;
	    end loop;
	 end loop;
	 return New_Shape;
      end Rotate_Z;
      
   begin
      if Axis = AXIS_X then
	 return Rotate_X(Shape);
      elsif Axis = AXIS_Y then
	 return Rotate_Y(Shape);
      elsif Axis = AXIS_Z then
	 return Rotate_Z(Shape);
      end if;
      return Shape;
   end Rotate;
   
   
   function Overlaps(Shape1, Shape2 : Shape_Matrix)
		    return Boolean is
   begin
      for X in Shape1'Range(1) loop
	 for Y in Shape1'Range(2) loop
	    for Z in Shape1'Range(3) loop
	       if X in Shape2'Range(1) and Y in Shape2'Range(2) and Z in Shape2'Range(3) then
		  if Shape1(X, Y, Z) and Shape2(X, Y, Z) then
		     return True;
		  end if;
	       end if;
	    end loop;
	 end loop;
      end loop;
      return False;
   end Overlaps;
   
   
   function Fits(Shape1, Shape2 : Shape_Matrix)
		return Boolean is
   begin
      for X in Shape1'Range(1) loop
	 for Y in Shape1'Range(2) loop
	    for Z in Shape1'Range(3) loop
	       if X in Shape2'Range(1) and Y in Shape2'Range(2) and Z in Shape2'Range(3) then
		  if Shape1(X, Y, Z) and not Shape2(X, Y, Z) then
		     return False;
		  end if;
	       end if;
	    end loop;
	 end loop;
      end loop;
      return True;
   end Fits;
   
   
   function Inverse(Shape : Shape_Matrix)
		   return Shape_Matrix is
      Ret_Shape : Shape_Matrix(Shape'Range(1), Shape'Range(2), Shape'Range(3));
   begin
      for X in Shape'Range(1) loop
	 for Y in Shape'Range(2) loop
	    for Z in Shape'Range(3) loop
	       Ret_Shape(X, Y, Z) := not Shape(X, Y, Z);
	    end loop;
	 end loop;
      end loop;
      return Ret_Shape;
   end Inverse;
   
   
   function Corner(Shape : Shape_Matrix)
		  return Boolean is
   begin
      return False;
   end Corner;
   
   
   function Center(Shape : Shape_Matrix)
		  return Axis_Vector is
      Ret_Vector : Axis_Vector;
   begin
      Ret_Vector(AXIS_X) := (Shape'Last(1) - Shape'First(1)) / 2;
      Ret_Vector(AXIS_Y) := (Shape'Last(2) - Shape'First(2)) / 2;
      Ret_Vector(Axis_Z) := (Shape'Last(3) - Shape'First(3)) / 2;
      return Ret_Vector;
   end Center;
   
   function Standardize(Shape : Shape_Matrix; I_Size, Offset : Axis_Vector)
		       return Shape_Matrix is
      New_Shape : Shape_Matrix(1..Integer'Max(I_Size(AXIS_X), Size(Shape, AXIS_X)), 
			       1..Integer'Max(I_Size(AXIS_Y), Size(Shape, AXIS_Y)), 
			       1..Integer'Max(I_Size(AXIS_Z), Size(Shape, AXIS_Z)));
   begin
      --Put("STANDARDIZE----------------------------------------------------------------------");
      for Z in New_Shape'Range(3) loop
	 for Y in New_Shape'Range(2) loop
	    for X in New_Shape'Range(1) loop
	       if (X - Offset(AXIS_X)) in New_Shape'Range(1) and (Y - Offset(AXIS_Y)) in New_Shape'Range(2) and (Z - Offset(AXIS_Z)) in New_Shape'Range(3) then
		  if (X - Offset(AXIS_X)) in Shape'Range(1) and (Y - Offset(AXIS_Y)) in Shape'Range(2) and (Z - Offset(AXIS_Z)) in Shape'Range(3) then
		     New_Shape(X, Y, Z) := Shape(X-Offset(AXIS_X), Y-Offset(AXIS_Y), Z-Offset(AXIS_Z));
		  else
		     New_Shape(X, Y, Z) := False;
		  end if;
	       else
		  New_Shape(X, Y, Z) := False;
	       end if;
	    end loop;
	 end loop;
      end loop;	
      return New_Shape;
   end Standardize;
   
   function Subshape(Shape : Shape_Matrix; Size, Offset : Axis_Vector)
		    return Shape_Matrix is
      New_Shape : Shape_Matrix(1..Size(AXIS_X), 1..Size(AXIS_Y), 1..Size(AXIS_Z));
   begin
      if (Size(AXIS_X) + Offset(AXIS_X)) in Shape'Range(1) and (Size(AXIS_Y) + Offset(AXIS_Y)) in Shape'Range(2) and (Size(AXIS_Z) + Offset(AXIS_Z)) in Shape'Range(3) then 
	 for Z in (Offset(AXIS_Z))..(Offset(AXIS_Z) + Size(AXIS_Z) - 1) loop
	    for Y in (Offset(AXIS_Y))..(Offset(AXIS_Y) + Size(AXIS_Y) - 1) loop
	       for X in (Offset(AXIS_X))..(Offset(AXIS_X) + Size(AXIS_X) - 1) loop
		  New_Shape(X - Offset(AXIS_X) +1, Y - Offset(AXIS_Y)+1 , Z - Offset(AXIS_Z)+1) := Shape(X, Y, Z);
		--New_Shape(X, Y, Z) := Shape(X - Offset(AXIS_X) +1, Y - Offset(AXIS_Y)+1 , Z - Offset(AXIS_Z)+1);	     
	       end loop;
	    end loop;
	 end loop;
      end if;
      return New_Shape;
   end Subshape;
   
   function Volume(Shape : Shape_Matrix)
		  return Integer is
      Volle : Integer := 0;
   begin
      for Z in Shape'Range(3) loop
	 for Y in Shape'Range(2) loop
	    for X in Shape'Range(1) loop
	       if Shape(X, Y, Z) then
		  Volle := Volle + 1;
	       end if;
	    end loop;
	 end loop;
      end loop;
      return Volle;
   end Volume;
   
   function Size(Shape : Shape_Matrix; Axis : Axis_Enum)
		return Integer is
   begin
      if Axis = AXIS_X then
	 return Shape'Length(1);
      elsif Axis = AXIS_Y then
	 return Shape'Length(2);
      elsif Axis = AXIS_Z then
	 return Shape'Length(3);
      end if;
      return 0;
   end Size;
   
   --|----------------------------------------------------------------------------------
   function Rotate(Shape : Shape_Matrix; Rotations : Axis_Vector) return Shape_Access is
      function Rotater(Shaped : Shape_Matrix; Rot : Axis_Vector) return Shape_Matrix is
	 V : Axis_Vector := Rot;
      begin
--	 Put("I ROTATER: --------------------");
--	 New_Line;
--	 Put("Last: ");
--	 Put(Shaped'Last(1), 0);
--	 Put(" ");
--	 Put(Shaped'Last(2), 0);
--	 Put(" ");
--	 Put(Shaped'Last(3), 0);
--	 New_Line;
--	 Put("First: ");
--	 Put(Shaped'First(1), 0);
--	 Put(" ");
--	 Put(Shaped'First(2), 0);
--	 Put(" ");
--	 Put(Shaped'First(3), 0);
--	 New_Line;
	 if V(AXIS_X) > 0 then
	    V(AXIS_X) := V(AXIS_X) - 1;
	    return Rotater(Rotate(Shaped, AXIS_X), V);
	 end if;
	 if V(AXIS_Y) > 0 then
	    V(AXIS_Y) := V(AXIS_Y) - 1;
	    return Rotater(Rotate(Shaped, AXIS_Y), V);
	 end if;
	 if V(AXIS_Z) > 0 then
	    V(AXIS_Z) := V(AXIS_Z) - 1;
	    return Rotater(Rotate(Shaped, AXIS_Z), V);
	 end if;
	 return Shaped;
      end Rotater;
      
      function Rot_Dim(Moddi : in Axis_Vector; Rots : in Axis_Vector) return Axis_Vector is
	 Temp : Axis_Vector := Moddi;
      begin
	 if Rots(AXIS_X) mod 2 = 1 then
	    Temp := (Temp(AXIS_X), Temp(AXIS_Z), Temp(AXIS_Y));
	 end if;
	 if Rots(AXIS_Y) mod 2 = 1 then
	    Temp := (Temp(AXIS_Z), Temp(AXIS_Y), Temp(AXIS_X));
	 end if;
	 if Rots(AXIS_Z) mod 2 = 1 then
	    Temp := (Temp(AXIS_Y), Temp(AXIS_X), Temp(AXIS_Z));
	 end if;
	 return Temp;
      end Rot_Dim;
        
      T_Shape : aliased Shape_Matrix := Rotater(Shape, Rotations);
      T_Size : Axis_Vector := (Size(Shape, AXIS_X), Size(Shape, AXIS_Y), Size(Shape, AXIS_Z));
      T_V : Axis_Vector := Rot_Dim(T_Size, Rotations);
      Ptr : Shape_Access := new Shape_Matrix(1..T_V(AXIS_X), 1..T_V(AXIS_Y), 1..T_V(AXIS_Z));
   begin
      --Put("Vad du vill, rotationer: ");New_Line;
       --Put(Size(Shape, AXIS_X), 0); Put(", ");Put(Size(Shape, AXIS_Y),0); Put(", ");Put(Size(Shape, AXIS_Z),0);New_Line;
      --Put(Rotations(AXIS_X),0); Put(", ");Put(Rotations(AXIS_Y),0); Put(", ");Put(Rotations(AXIS_Z),0);New_Line;
      --Put(T_Size(AXIS_X),0); Put(", ");Put(T_Size(AXIS_Y),0); Put(", ");Put(T_Size(AXIS_Z),0);New_Line;
      --Put(T_V(AXIS_X),0); Put(", ");Put(T_V(AXIS_Y),0); Put(", ");Put(T_V(AXIS_Z),0);New_Line;
      Ptr.all := T_Shape;
      --Put("I ROTATER: --------------------");
      --New_Line;
      --Put("Last: ");
      --Put(Ptr.all'Last(1), 0);
      --Put(" ");
      --Put(Ptr.all'Last(2), 0);
      --Put(" ");
      --Put(Ptr.all'Last(3), 0);
      --New_Line;
--      Put("First: ");
--      Put(Ptr.all'First(1), 0);
--      Put(" ");
--      Put(Ptr.all'First(2), 0);
--      Put(" ");
--      Put(Ptr.all'First(3), 0);
--      New_Line;      
      return Ptr;
   end Rotate;   
   
   
   
end Shape;
