

package body Geometry is
   
   function Length(In_Vector: in Axis_Vector) return Integer is
   begin
      return (In_Vector(AXIS_X)**2 + In_Vector(AXIS_Y)**2 + In_Vector(AXIS_Z)**2); --sqrt this
   end Length;
   
end Geometry;
