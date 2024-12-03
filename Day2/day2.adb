-----------------------------------------------------------
-- Advent of Code 2024, Day 2
-----------------------------------------------------------
with Ada.Text_IO; use Ada.Text_IO;
with GNAT.String_Split; use GNAT.String_Split;

procedure day2 is

   function Get_Filename return String is
      Line : String (1 .. 1_000);
      Last : Natural;
   begin
      Put ("Enter filename: ");
      Get_Line (Line, Last);
      return Line (1 .. Last);
   end Get_Filename;

   Tokens : Slice_Set;
   F : File_Type;
   FName : String := Get_Filename;
   num_Reports : Integer := 0;
   FirstX, Safe : Boolean;
   Last_Num, Try0, Try1, Try2 : Slice_Number;

   procedure IsSafe(Tokens: in Slice_Set; first_time: in Boolean; bool_Safe: out Boolean; last: in out Slice_Number) is
      A1, A2, level_diff : Integer;
      bool_Increasing : Boolean;
   begin
      for I in 1 .. Slice_Count (Tokens) - 1 loop
         if first_time then
            A1 := Integer'Value(Slice(Tokens, I));
            A2 := Integer'Value(Slice(Tokens, I+1));
         else
            if I >= last then
               exit when I+1 = Slice_Count (Tokens);
               A1 := Integer'Value(Slice(Tokens, I+1));
               A2 := Integer'Value(Slice(Tokens, I+2));
            elsif I+1 = last then
               exit when I+2 > Slice_Count (Tokens);
               A1 := Integer'Value(Slice(Tokens, I));
               A2 := Integer'Value(Slice(Tokens, I+2));
            else
               A1 := Integer'Value(Slice(Tokens, I));
               A2 := Integer'Value(Slice(Tokens, I+1));
            end if;
         end if;

         if I = 1 then
            if A1 < A2 then
               bool_Increasing := True;
            else
               bool_Increasing := False;
            end if;
         end if;

         level_diff := abs(A1-A2);
         if level_diff < 1 or level_diff > 3 then
            bool_Safe := False;
         else
            if bool_Increasing then
               if A1 < A2 then
                  bool_Safe := True;
               else
                  bool_Safe := False;
               end if;
            else
               if A1 > A2 then
                  bool_Safe := True;
               else
                  bool_Safe := False;
               end if;

            end if;
         end if;

         if not bool_Safe then
            last := I;
            exit;
         end if;

      end loop;
   end IsSafe;

begin
   Open (F, In_File, FName);
   while not End_Of_File(F) loop
      Create (Tokens, Get_Line(F), " ", Multiple);

      Last_Num := 1;
      FirstX := True;
      IsSafe(Tokens, FirstX, Safe, Last_Num);
      if Safe then
         num_Reports := num_Reports + 1;
      end if;

   end loop;
   Close (F);

   Put_Line ("*** Day 2, Part 1 *** ");
   Put ("The number of safe reports is: ");
   Put_Line (integer'Image(num_Reports));

   num_Reports := 0;
   Open (F, In_File, FName);
   while not End_Of_File(F) loop
      Create (Tokens, Get_Line(F), " ", Multiple);

      Last_Num := 1;
      FirstX := True;
      IsSafe(Tokens, FirstX, Safe, Last_Num);

      if not Safe then
         FirstX := False;
         Try1 := Last_Num;
         Try2 := Last_Num + 1;

         if Last_Num = 2 then
            Try0 := Last_Num - 1;
            IsSafe(Tokens, FirstX, Safe, Try0);
         end if;
         
         if not Safe then
            IsSafe(Tokens, FirstX, Safe, Try1);
            if not Safe then
               IsSafe(Tokens, FirstX, Safe, Try2);
            end if;
         end if;

      end if;

      if Safe then
         num_Reports := num_Reports + 1;
      end if;

   end loop;
   Close (F);

   New_Line;
   Put_Line ("*** Day 2, Part 2 *** ");
   Put ("Applying the Problem Dampener, the number of safe reports is now: ");
   Put (integer'Image(num_Reports));

end day2;

