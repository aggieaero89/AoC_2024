-----------------------------------------------------------
-- Advent of Code 2024, Day 3
-----------------------------------------------------------
with Ada.Text_IO; use Ada.Text_IO;
with GNAT.RegPat; use GNAT.RegPat;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure day3 is

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
   A1, A2 : Integer;
   Sum_Total : Integer;

   RegEx_Pattern : constant String := "mul\(([0-9]+),([0-9]+)\)";
   String_First, String_Iterator, String_Last : Positive;
   Compiled_Exp : Pattern_Matcher := Compile(RegEx_Pattern);
   Found_It : Boolean;

   Build_String       : Unbounded_String;
   bool_Do            : boolean;
   RegEx_Pattern_Do   : constant String := "(do\(\))";
   RegEx_Pattern_Dont : constant String := "(don't\(\))";
   Compiled_Exp_Do    : Pattern_Matcher := Compile(RegEx_Pattern_Do);
   Compiled_Exp_Dont  : Pattern_Matcher := Compile(RegEx_Pattern_Dont);

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

   procedure Search_String(
      Compiled_Regex  : in Pattern_Matcher;
      String_To_Parse : in String;
      First           : out Positive;
      Last            : out Positive;
      Found           : out Boolean) is

      Result : Match_Array(0 .. 1);
   begin
      Match(Compiled_Regex, String_To_Parse, Result);
      if Result(0) = No_Match then
         Last := String_To_Parse'Last;
         Found := False;
      else
         First := Result(1).First;
         Last  := Result(1).Last;
         Found := True;
       end if;
   end Search_String;

begin
   Sum_Total := 0;
   Open (F, In_File, FName);
   while not End_Of_File(F) loop
      declare
         Memory_Line : String := Get_Line(F);
      begin
         String_Iterator := Memory_Line'First;
         String_Last     := 1;

         loop
            Search_String(
               Compiled_Regex  => Compiled_Exp,
               String_To_Parse => Memory_Line(String_Iterator .. Memory_Line'Last),
               First_Num       => A1,
               Second_Num      => A2,
               Last            => String_Last,
               Found           => Found_It);

            exit when not Found_It;

            Sum_Total := Sum_Total + (A1 * A2);

            String_Iterator := String_Last + 1;

         end loop;
      end;

   end loop;
   Close (F);

   New_Line;
   Put_Line ("*** Day 3, Part 1 *** ");
   Put ("The sum of the multiplications is: ");
   Put (Integer'Image(Sum_Total));
   New_Line(2);

   bool_Do   := True;
   Sum_Total := 0;
   Open (F, In_File, FName);
   while not End_Of_File(F) loop
      declare
         Memory_Line : String := Get_Line(F);
      begin
         String_Iterator := Memory_Line'First;
         String_Last     := 1;
         Build_String    := Null_Unbounded_String;

         loop
            if bool_Do then
               Search_String(
                  Compiled_Regex  => Compiled_Exp_Dont,
                  String_To_Parse => Memory_Line(String_Iterator .. Memory_Line'Last),
                  First           => String_First,
                  Last            => String_Last,
                  Found           => Found_It);

               if not Found_It then
                  Append(Build_String, Memory_Line(String_Iterator .. Memory_Line'Last));
                  exit;
               end if;

               Append(Build_String, Memory_Line(String_Iterator .. (String_First - 1)));
               String_Iterator := String_Last;

               bool_Do := False;
            end if;

            if not bool_Do then
               Search_String(
                  Compiled_Regex  => Compiled_Exp_Do,
                  String_To_Parse => Memory_Line(String_Iterator .. Memory_Line'Last),
                  First           => String_First,
                  Last            => String_Last,
                  Found           => Found_It);

               exit when not Found_It;

               String_Iterator := String_Last;

               bool_Do := True;
            end if;

         end loop;

         declare
            Temp_String : constant String := To_String(Build_String);
         begin
            String_Iterator := Temp_String'First;
            String_Last     := 1;

            loop
               Search_String(
                  Compiled_Regex  => Compiled_Exp,
                  String_To_Parse => Temp_String(String_Iterator .. Temp_String'Last),
                  First_Num       => A1,
                  Second_Num      => A2,
                  Last            => String_Last,
                  Found           => Found_It);

               exit when not Found_It;

               Sum_Total := Sum_Total + (A1 * A2);

               String_Iterator := String_Last + 1;

            end loop;
         end;
      end;

   end loop;
   Close (F);

   New_Line;
   Put_Line ("*** Day 3, Part 2 *** ");
   Put ("Applying enable/disable instructions, the sum of the multiplications is: ");
   Put (Integer'Image(Sum_Total));
   
end day3;

