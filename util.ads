--with / use på unbounded?
with Ada.Strings.Unbounded;

package Util is
   package Str renames Ada.Strings.Unbounded;
   
   function Next_Space_Index(Item: in Str.Unbounded_String; Start: in Integer) return Integer;
   function Next_Index(Item: in Str.Unbounded_String; Start: in Integer; Pat: in String) return Integer;
end Util;
