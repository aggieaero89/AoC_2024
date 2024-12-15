-----------------------------------------------------------
-- Advent of Code 2024, Day 13
-----------------------------------------------------------
with Ada.Text_IO; use Ada.Text_IO;
with GNAT.String_Split; use GNAT.String_Split;
with GNAT.RegPat; use GNAT.RegPat;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers; use Ada.Containers;
with Ada.Containers.Vectors;

procedure day5 is

   function Get_Filename return String is
      Line : String (1 .. 1_000);
      Last : Natural;
   begin
      Put ("Enter filename: ");
      Get_Line (Line, Last);
      return Line (1 .. Last);
   end Get_Filename;

   F : File_Type;
   FName : String := Get_Filename;

   type Page_Order_Rule is record
      X : Integer;
      Y : Integer;
   end record;

   package Rule_Vectors is new Ada.Containers.Vectors(Natural,Page_Order_Rule);
   subtype Vector is Rule_Vectors.Vector;
   use all type Vector;
   V : Vector;

   package Sort_Vectors is new Ada.Containers.Vectors(Natural,Integer);
   subtype Sort_Vec is Sort_Vectors.Vector;
   use all type Sort_Vec;
   S : Sort_Vec;
   X_index, Y_index : Integer;

   Rule : Page_Order_Rule;
   Read_Rules : Boolean;
   Sum_Total_Good, Sum_Total_Bad, Mid_Val : Integer;
   Tokens : Slice_Set;

   RegEx_Pattern : constant String := "([0-9]+)\|([0-9]+)";
   String_Iterator, String_Last : Positive;
   Compiled_Exp : Pattern_Matcher := Compile(RegEx_Pattern);
   Found_It : Boolean;

   procedure Search_String(
      Compiled_Regex  : in Pattern_Matcher;
      String_To_Parse : in String;
      First_Num       : out Integer;
      Second_Num      : out Integer;
      Last            : out Positive;
      Found           : out Boolean) is

      Result : Match_Array(0 .. 2);
   begin
      Match(Compiled_Regex, String_To_Parse, Result);
      if Result(0) = No_Match then
         First_Num  := 0;
         Second_Num := 0;
         Last := String_To_Parse'Last;
         Found := False;
      else
         First_Num  := Integer'Value(String_To_Parse(Result(1).First .. Result(1).Last));
         Second_Num := Integer'Value(String_To_Parse(Result(2).First .. Result(2).Last));
         Last := Result(2).Last+1;
         Found := True;
      end if;
   end Search_String;

function Slice_to_Vec(Tokens: in Slice_Set) return Sort_Vec is
      Sort_Vector : Sort_Vec;
   begin
      for I in 1 .. Slice_Count (Tokens) loop
         Sort_Vector.Append(Integer'Value( Slice(Tokens, I) ));
      end loop;

      return Sort_Vector;
   end Slice_to_Vec;

function Sort_Rules_Vec(Rules: in Vector; Sort_Rules: in out Sort_Vec) return Boolean is
      ReSorted, Is_X, Is_Y: Boolean;
   begin
      ReSorted := False;
      for I of Rules loop
         Is_X := False;
         Is_Y := False;
         for J in reverse Sort_Rules.First_Index .. Sort_Rules.Last_Index loop
            if I.X = Sort_Rules(J) then
               X_index := J;
               Is_X := True;
            elsif I.Y = Sort_Rules(J) then
               Y_index := J;
               Is_Y := True;
            end if;
         end loop;
         
         if Is_X and Is_Y then
            if Y_index < X_index then
               ReSorted := True;
               for J in reverse Y_index .. X_index-1 loop
                  Sort_Vectors.Swap(Sort_Rules,J,J+1);
               end loop;
            end if;
         end if;

      end loop;

      Return ReSorted;
   end Sort_Rules_Vec;

   function Mid_Vec_Val(Rules: in Vector; Sort_Rules: in out Sort_Vec) return Integer is
      Mid_Index : Integer;
      Is_Sorted : Boolean;
   begin
      Is_Sorted := Sort_Rules_Vec(Rules,Sort_Rules);

      Mid_Index := Integer(Sort_Rules.Length) / 2; -- no need to add 1 because index is Zero-based

      return Sort_Rules(Mid_Index);

   end Mid_Vec_Val;

begin
   Sum_Total_Good := 0;
   Sum_Total_Bad := 0;
   Read_Rules := True;

   Open (F, In_File, FName);
   while Read_Rules loop
      declare
         Memory_Line : String := Get_Line(F);
      begin
         if Memory_Line = "" then
            Read_Rules := False;
            exit;
         end if;

         String_Iterator := Memory_Line'First;
         String_Last     := 1;

         Search_String(
            Compiled_Regex  => Compiled_Exp,
            String_To_Parse => Memory_Line(String_Iterator .. Memory_Line'Last),
            First_Num       => Rule.X,
            Second_Num      => Rule.Y,
            Last            => String_Last,
            Found           => Found_It);

         V.Append(Rule);
      end;
   end loop;
   
   while not End_Of_File(F) loop
      Create (Tokens, Get_Line(F), ",");
      S := Slice_to_Vec(Tokens);

      if Sort_Rules_Vec(V, S) then
         Mid_Val := Mid_Vec_Val(V,S);
         Sum_Total_Bad := Sum_Total_Bad + Mid_Val;
      else
         Mid_Val := Mid_Vec_Val(V,S);
         Sum_Total_Good := Sum_Total_Good + Mid_Val;
      end if;
   end loop;

   Close (F);

   New_Line;
   Put_Line ("*** Day 13, Part 1 *** ");
   Put ("Fewest tokens to spend for all prizes is: ");
   Put (Integer'Image(Sum_Total_Good));
   New_Line(2);


   New_Line;
   Put_Line ("*** Day 13, Part 2 *** ");
   Put ("Fewest tokens to spend for all prizes is: ");
   Put (Integer'Image(Sum_Total_Bad));
   New_Line(2);


end day5;

