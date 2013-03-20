--|-------------------------------------------------------------------------------------------
--| Tobias Hultqvist tobhu543, Ludvig En luden963,
--| Viktor Ringdahl vikri500,  Sebastian Parmbäck sebpa096
--|
--| The geometry package includes various types and generic functions that
--| is used in other packages. It's essentially a helper package.
--|-------------------------------------------------------------------------------------------

package Geometry is
   type Axis_Enum is (AXIS_X, AXIS_Y, AXIS_Z);
   type Axis_Vector is array(Axis_Enum) of Integer;
   function Length(In_Vector: in Axis_Vector) return Integer;
   
private
   
end Geometry;
