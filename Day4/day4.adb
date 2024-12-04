-----------------------------------------------------------
-- Advent of Code 2024, Day 4
-----------------------------------------------------------
with Ada.Text_IO; use Ada.Text_IO;

procedure day4 is

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
   Total_Num : Integer;
   Char : Character;
   TheLine : String (1 .. 200);
   Knt, TheLast : Natural;

   Max_Row : Natural;
   Max_Col : Natural;

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
      Word_Find : TwoDim_Matrix;

   begin
      Total_Num := 0;
      Open (F, In_File, FName);
      for I in 1 .. Max_Row loop
         for J in 1 .. Max_Col loop
            Get(F,Char);
            Word_Find(I,J) := Char;
         end loop;
      end loop;
      Close (F);

      for I in 1 .. Max_Row loop
         for J in 1 .. Max_Col loop
            if Word_Find(I,J) = 'X' then

               --look North
               if I >= 4 then
                  if Word_Find(I-1,J) = 'M' then
                     if Word_Find(I-2,J) = 'A' then
                        if Word_Find(I-3,J) = 'S' then
                           Total_Num := Total_Num + 1;
                        end if;
                     end if;
                  end if;
               end if;

               --look South
               if I <= (Max_Row - 3) then
                  if Word_Find(I+1,J) = 'M' then
                     if Word_Find(I+2,J) = 'A' then
                        if Word_Find(I+3,J) = 'S' then
                           Total_Num := Total_Num + 1;
                        end if;
                     end if;
                  end if;
               end if;
               
               --look East
               if J <= (Max_Col - 3) then
                  if Word_Find(I,J+1) = 'M' then
                     if Word_Find(I,J+2) = 'A' then
                        if Word_Find(I,J+3) = 'S' then
                           Total_Num := Total_Num + 1;
                        end if;
                     end if;
                  end if;
               end if;
               
               --look West
               if J >= 4 then
                  if Word_Find(I,J-1) = 'M' then
                     if Word_Find(I,J-2) = 'A' then
                        if Word_Find(I,J-3) = 'S' then
                           Total_Num := Total_Num + 1;
                        end if;
                     end if;
                  end if;
               end if;
               
               --look North-East
               if I >= 4 and J <= (Max_Col - 3) then
                  if Word_Find(I-1,J+1) = 'M' then
                     if Word_Find(I-2,J+2) = 'A' then
                        if Word_Find(I-3,J+3) = 'S' then
                           Total_Num := Total_Num + 1;
                        end if;
                     end if;
                  end if;
               end if;

               --look South-East
               if I <= (Max_Row - 3) and J <= (Max_Col - 3) then
                  if Word_Find(I+1,J+1) = 'M' then
                     if Word_Find(I+2,J+2) = 'A' then
                        if Word_Find(I+3,J+3) = 'S' then
                           Total_Num := Total_Num + 1;
                        end if;
                     end if;
                  end if;
               end if;

               --look North-West
               if I >= 4 and J >= 4 then
                  if Word_Find(I-1,J-1) = 'M' then
                     if Word_Find(I-2,J-2) = 'A' then
                        if Word_Find(I-3,J-3) = 'S' then
                           Total_Num := Total_Num + 1;
                        end if;
                     end if;
                  end if;
               end if;

               --look South-West
               if I <= (Max_Row - 3) and J >= 4 then
                  if Word_Find(I+1,J-1) = 'M' then
                     if Word_Find(I+2,J-2) = 'A' then
                        if Word_Find(I+3,J-3) = 'S' then
                           Total_Num := Total_Num + 1;
                        end if;
                     end if;
                  end if;
               end if;

            end if;
         end loop;
      end loop;

      New_Line;
      Put_Line ("*** Day 4, Part 1 *** ");
      Put ("Total number of times XMAS appears is: ");
      Put (Integer'Image(Total_Num));
      New_Line(2);

      Total_Num := 0;

      for I in 1 .. Max_Row loop
         for J in 1 .. Max_Col loop
            if Word_Find(I,J) = 'A' then
               if I > 1 and I < Max_Row and J > 1 and J < Max_Col then
                     
                  --     M   M
                  --       A
                  --     S   S
                  if Word_Find(I-1,J-1) = 'M' then
                     if Word_Find(I-1,J+1) = 'M' then
                        if Word_Find(I+1,J+1) = 'S' then
                           if Word_Find(I+1,J-1) = 'S' then
                              Total_Num := Total_Num + 1;
                           end if;
                        end if;
                     end if;
                  end if;

                  --     M   S
                  --       A
                  --     M   S
                  if Word_Find(I-1,J-1) = 'M' then
                     if Word_Find(I-1,J+1) = 'S' then
                        if Word_Find(I+1,J+1) = 'S' then
                           if Word_Find(I+1,J-1) = 'M' then
                              Total_Num := Total_Num + 1;
                           end if;
                        end if;
                     end if;
                  end if;
               
                  --     S   M
                  --       A
                  --     S   M
                  if Word_Find(I-1,J-1) = 'S' then
                     if Word_Find(I-1,J+1) = 'M' then
                        if Word_Find(I+1,J+1) = 'M' then
                           if Word_Find(I+1,J-1) = 'S' then
                              Total_Num := Total_Num + 1;
                           end if;
                        end if;
                     end if;
                  end if;
               
                  --     S   S
                  --       A
                  --     M   M
                  if Word_Find(I-1,J-1) = 'S' then
                     if Word_Find(I-1,J+1) = 'S' then
                        if Word_Find(I+1,J+1) = 'M' then
                           if Word_Find(I+1,J-1) = 'M' then
                              Total_Num := Total_Num + 1;
                           end if;
                        end if;
                     end if;
                  end if;

               end if;
            end if;
         end loop;
      end loop;

      New_Line;
      Put_Line ("*** Day 4, Part 2 *** ");
      Put ("Total number of times X-MAS appears is: ");
      Put (Integer'Image(Total_Num));
   end;
   
end day4;

