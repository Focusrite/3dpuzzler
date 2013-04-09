package body Util is

   --Returns the index of the next ' '(space) after the given index
	function Next_Space_Index(Item: in Str; Start: in Integer)
									return Integer is
	begin
   --below are procedures from Ada.Strings.Unbounded mostly
		return Next_Index(Item, Start, " ");
	end Next_Space_Index;

	--Returns the index of the first appearance in Item, after Start, of the pattern Pat
	function Next_Index(Item: in Str; Start: in Integer; Pat: in String) return Integer is
	begin
    --below are procedures from Ada.Strings.Unbounded mostly
		return Index(Slice(Item, Start, Length(Item)), Pat);
	end Next_Index;

end Util;