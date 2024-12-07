-----------------------------------------------------------
-- Advent of Code 2024, Day 6
-----------------------------------------------------------
with Ada.Text_IO; use Ada.Text_IO;

procedure day6 is

   function Get_Filename return String is
      Line : String (1 .. 1_000);
      Last : Natural;
   begin
      Put ("Enter filename: ");
      Get_Line (Line, Last);
      return Line (1 .. Last);
   end Get_Filename;

   type Direction is (North, East, West, South);

   type Point is record
      Row : Natural;
      Col : Natural;
      Dir : Direction;
   end record;

   F : File_Type;
   FName : String := Get_Filename;
   Total_Num : Integer;
   Char : Character;
   TheLine : String (1 .. 200);
   Knt, TheLast : Natural;

   Max_Row : Natural;
   Max_Col : Natural;

   Guard : Point;
   Copy_Guard : Point;
   On_Map : Boolean;
   Loop_Knt : Integer;

begin
   Knt := 0;
   Open (F, In_File, FName);
   while not End_Of_File(F) loop
      Get_Line(F, TheLine, TheLast);
      Knt := Knt + 1;
   end loop;
   Close (F);
  
   Max_Row := Knt;
   Max_Col := TheLast;
   declare
      type TwoDim_Matrix is array(Natural range 1 .. Max_Row, Natural range 1 .. Max_Col) of Character;
      Lab_Map : TwoDim_Matrix;
      Copy_Map : TwoDim_Matrix;

      procedure Next_Step (X: in out Point; M : in out TwoDim_Matrix) is
      begin
         case X.Dir is
            when North =>
               if M(X.Row-1,X.Col) = '#' then
                  X.Dir := East;
               else
                  X.Row := X.Row - 1;
               end if;

            when East => null;
               if M(X.Row,X.Col+1) = '#' then
                  X.Dir := South;
               else
                  X.Col := X.Col + 1;
               end if;
               
            when South => null;
               if M(X.Row+1,X.Col) = '#' then
                  X.Dir := West;
               else
                  X.Row := X.Row + 1;
               end if;
               
            when West => null;
               if M(X.Row,X.Col-1) = '#' then
                  X.Dir := North;
               else
                  X.Col := X.Col - 1;
               end if;

         end case;
      end Next_Step;

   begin
      Total_Num := 0;
      Open (F, In_File, FName);
      for I in 1 .. Max_Row loop
         for J in 1 .. Max_Col loop
            Get(F,Char);
            Lab_Map(I,J) := Char;
            
            case Char is
               when '^' => Guard.Dir:=North; Guard.Row:=I; Guard.Col:=J;
               when '>' => Guard.Dir:=East; Guard.Row:=I; Guard.Col:=J;
               when 'v' => Guard.Dir:=South; Guard.Row:=I; Guard.Col:=J;
               when '<' => Guard.Dir:=West; Guard.Row:=I; Guard.Col:=J;
               when others => null;
            end case;
         end loop;
      end loop;
      Close (F);

      Copy_Map := Lab_Map;
      Copy_Guard := Guard;

      Lab_Map(Guard.Row,Guard.Col) := 'X';
      On_Map := True;
      loop
         Next_Step(Guard, Lab_Map);
         case Guard.Dir is
            when North =>
               if Guard.Row = 1 then
                  On_Map := False;
               end if;

            when East =>
               if Guard.Col = Max_Col then
                  On_Map := False;
               end if;
               
            when South =>
               if Guard.Row = Max_Row then
                  On_Map := False;
               end if;

            when West =>
               if Guard.Col = 1 then
                  On_Map := False;
               end if;
               
         end case;

         Lab_Map(Guard.Row,Guard.Col) := 'X';
         exit when not On_Map;

      end loop;

      Total_Num := 0;
      for I in 1 .. Max_Row loop
         for J in 1 .. Max_Col loop
            if Lab_Map(I,J) = 'X' then
               Total_Num := Total_Num + 1;
            end if;
         end loop;
      end loop;

      New_Line;
      Put_Line ("*** Day 6, Part 1 *** ");
      Put ("Total number of distinct guard visits is: ");
      Put (Integer'Image(Total_Num));
      New_Line(2);

      Total_Num := 0;
      for I in 1 .. Max_Row loop
         for J in 1 .. Max_Col loop
            Lab_Map := Copy_Map;
            Guard := Copy_Guard;

            if not (Guard.Row = I and Guard.Col = J) then
               Lab_Map(I,J) := '#';

               Loop_Knt := 0;
               Lab_Map(Guard.Row,Guard.Col) := 'X';
               On_Map := True;
               loop
                  Next_Step(Guard, Lab_Map);
                  case Guard.Dir is
                     when North =>
                        if Guard.Row = 1 then
                           On_Map := False;
                        end if;

                     when East =>
                        if Guard.Col = Max_Col then
                           On_Map := False;
                        end if;
                        
                     when South =>
                        if Guard.Row = Max_Row then
                           On_Map := False;
                        end if;

                     when West =>
                        if Guard.Col = 1 then
                           On_Map := False;
                        end if;
                        
                  end case;

                  Lab_Map(Guard.Row,Guard.Col) := 'X';
                  exit when not On_Map;

                  Loop_Knt := Loop_Knt + 1;
                  exit when Loop_Knt > 10_000;

               end loop;

               if On_Map then
                  Total_Num := Total_Num + 1;
               end if;

            end if;
         end loop;
      end loop;


      New_Line;
      Put_Line ("*** Day 6, Part 2 *** ");
      Put ("Total number of different obstruction position is: ");
      Put (Integer'Image(Total_Num));
   end;
   
end day6;

