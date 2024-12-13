-----------------------------------------------------------
-- Advent of Code 2024, Day 13
-----------------------------------------------------------
with Ada.Text_IO; use Ada.Text_IO;
with GNAT.RegPat; use GNAT.RegPat;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure day13 is

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

   type Point is record
      X : Long_Long_Integer;
      Y : Long_Long_Integer;
   end record;

   Button_A, Button_B, Prize : Point;
   Press_A, Press_B : Long_Long_Float;
   Sub_Knt : Positive;
   Sum_Total : Long_Long_Integer;

   RegEx_Pattern_Button : constant String := "X\+([0-9]+), Y\+([0-9]+)";
   RegEx_Pattern_Prize : constant String := "X\=([0-9]+), Y\=([0-9]+)";
   String_Iterator, String_Last : Positive;
   Compiled_Exp_Button : Pattern_Matcher := Compile(RegEx_Pattern_Button);
   Compiled_Exp_Prize : Pattern_Matcher := Compile(RegEx_Pattern_Prize);
   Found_It : Boolean;


   procedure Search_String(
      Compiled_Regex  : in Pattern_Matcher;
      String_To_Parse : in String;
      First_Num       : out Long_Long_Integer;
      Second_Num      : out Long_Long_Integer;
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
         First_Num  := Long_Long_Integer'Value(String_To_Parse(Result(1).First .. Result(1).Last));
         Second_Num := Long_Long_Integer'Value(String_To_Parse(Result(2).First .. Result(2).Last));
         Last := Result(2).Last+1;
         Found := True;
      end if;
   end Search_String;

begin
   Sum_Total := 0;
   Sub_Knt := 1;

   Open (F, In_File, FName);
   while not End_Of_File(F) loop
      declare
         Memory_Line : String := Get_Line(F);
      begin
         String_Iterator := Memory_Line'First;
         String_Last     := 1;

         case Sub_Knt is
            when 1 =>
               Search_String(
                  Compiled_Regex  => Compiled_Exp_Button,
                  String_To_Parse => Memory_Line(String_Iterator .. Memory_Line'Last),
                  First_Num       => Button_A.X,
                  Second_Num      => Button_A.Y,
                  Last            => String_Last,
                  Found           => Found_It);
               
               Sub_Knt := 2;

            when 2 =>
               Search_String(
                  Compiled_Regex  => Compiled_Exp_Button,
                  String_To_Parse => Memory_Line(String_Iterator .. Memory_Line'Last),
                  First_Num       => Button_B.X,
                  Second_Num      => Button_B.Y,
                  Last            => String_Last,
                  Found           => Found_It);

               Sub_Knt := 3;

            when 3 =>
               Search_String(
                  Compiled_Regex  => Compiled_Exp_Prize,
                  String_To_Parse => Memory_Line(String_Iterator .. Memory_Line'Last),
                  First_Num       => Prize.X,
                  Second_Num      => Prize.Y,
                  Last            => String_Last,
                  Found           => Found_It);

               Sub_Knt := 4;

               Press_B := Long_Long_Float(Prize.Y*Button_A.X - Button_A.Y*Prize.X) / Long_Long_Float(Button_B.Y*Button_A.X - Button_A.Y*Button_B.X);
               Press_A := (Long_Long_Float(Prize.X) - Long_Long_Float(Button_B.X)*Press_B) / Long_Long_Float(Button_A.X);

               if (Press_B=Long_Long_Float'Truncation(Press_B)) and (Press_A=Long_Long_Float'Truncation(Press_A)) then
                  Sum_Total := Sum_Total + Long_Long_Integer(Press_A*3.0 + Press_B*1.0);
               end if;

            when others =>
               Sub_Knt := 1;

         end case;

      end;

   end loop;
   Close (F);

   New_Line;
   Put_Line ("*** Day 13, Part 1 *** ");
   Put ("Fewest tokens to spend for all prizes is: ");
   Put (Long_Long_Integer'Image(Sum_Total));
   New_Line(2);


   Sum_Total := 0;
   Sub_Knt := 1;

   Open (F, In_File, FName);
   while not End_Of_File(F) loop
      declare
         Memory_Line : String := Get_Line(F);
      begin
         String_Iterator := Memory_Line'First;
         String_Last     := 1;

         case Sub_Knt is
            when 1 =>
               Search_String(
                  Compiled_Regex  => Compiled_Exp_Button,
                  String_To_Parse => Memory_Line(String_Iterator .. Memory_Line'Last),
                  First_Num       => Button_A.X,
                  Second_Num      => Button_A.Y,
                  Last            => String_Last,
                  Found           => Found_It);
               
               Sub_Knt := 2;

            when 2 =>
               Search_String(
                  Compiled_Regex  => Compiled_Exp_Button,
                  String_To_Parse => Memory_Line(String_Iterator .. Memory_Line'Last),
                  First_Num       => Button_B.X,
                  Second_Num      => Button_B.Y,
                  Last            => String_Last,
                  Found           => Found_It);

               Sub_Knt := 3;

            when 3 =>
               Search_String(
                  Compiled_Regex  => Compiled_Exp_Prize,
                  String_To_Parse => Memory_Line(String_Iterator .. Memory_Line'Last),
                  First_Num       => Prize.X,
                  Second_Num      => Prize.Y,
                  Last            => String_Last,
                  Found           => Found_It);

               Sub_Knt := 4;

               Prize.X := Prize.X + 10_000_000_000_000;
               Prize.Y := Prize.Y + 10_000_000_000_000;

               Press_B := Long_Long_Float(Prize.Y*Button_A.X - Button_A.Y*Prize.X) / Long_Long_Float(Button_B.Y*Button_A.X - Button_A.Y*Button_B.X);
               Press_A := (Long_Long_Float(Prize.X) - Long_Long_Float(Button_B.X)*Press_B) / Long_Long_Float(Button_A.X);

               if (Press_B=Long_Long_Float'Truncation(Press_B)) and (Press_A=Long_Long_Float'Truncation(Press_A)) then
                  Sum_Total := Sum_Total + Long_Long_Integer(Press_A*3.0 + Press_B*1.0);
               end if;

            when others =>
               Sub_Knt := 1;

         end case;

      end;

   end loop;
   Close (F);

   New_Line;
   Put_Line ("*** Day 13, Part 2 *** ");
   Put ("Fewest tokens to spend for all prizes is: ");
   Put (Long_Long_Integer'Image(Sum_Total));
   New_Line(2);


end day13;

