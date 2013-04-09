with TJa.Sockets; use TJa.Sockets;
with Protocol;    use Protocol;
with Figure_List; use Figure_List;
with Figure;      use Figure;
with Algorithm;   use Algorithm;

with Ada.Strings.Unbounded;


package Runtime is
   package Str renames Ada.Strings.Unbounded;
   procedure Run;
   
end Runtime;
