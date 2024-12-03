-----------------------------------------------------------
-- Advent of Code 2024, Day 1
-----------------------------------------------------------
with Ada.Text_IO; use Ada.Text_IO;
with GNAT.String_Split; use GNAT.String_Split;

with Ada.Containers; use Ada.Containers;
with Ada.Containers.Doubly_Linked_Lists;

procedure day1 is

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
   A1, A2 : Integer;

   package DDL_Int is new Doubly_Linked_Lists (Integer); use DDL_Int;
   package DDL_Sorting is new DDL_Int.Generic_Sorting;

   DDL1_list : DDL_Int.List := DDL_Int.Empty_List;
   DDL2_list : DDL_Int.List := DDL_Int.Empty_List;

   DDL1_cursor : DDL_Int.Cursor;
   DDL2_cursor : DDL_Int.Cursor;

   Sum_Total : Integer := 0;
   Knt : Integer;

   Sim : Integer;
   Sim_Score : Integer := 0;

begin
   Open (F, In_File, FName);
   while not End_Of_File(F) loop
      Create (Tokens, Get_Line(F), " ", Multiple);
      A1 := Integer'Value(Slice(Tokens, 1));
      A2 := Integer'Value(Slice(Tokens, 2));

      DDL1_list.Append(A1);
      DDL2_list.Append(A2);

   end loop;
   Close (F);

   DDL_Sorting.Sort(DDL1_list);
   DDL_Sorting.Sort(DDL2_list);

   Knt := Integer(Length(DDL1_list));
   DDL2_cursor := First (DDL2_list);
   for Elem of DDL1_list loop
      Sum_Total := Sum_Total + abs(Elem - DDL2_list(DDL2_cursor));
      Knt := Knt - 1;
      exit when Knt = 0;
      Next (DDL2_cursor);
   end loop;

   Put_Line ("*** Day 1, Part 1 *** ");
   Put ("The total distance is: ");
   Put (Integer'Image(Sum_Total));
   
   for Elem of DDL1_list loop
      Sim := 0;
      for Elem2 of DDL2_list loop
         if Elem = Elem2 then
            Sim := Sim + Elem;
         end if;
      end loop;
      Sim_Score := Sim_Score + Sim;
   end loop;

   New_Line (2);
   Put_Line ("*** Day 1, Part 2 *** ");
   Put ("The similarity score is: ");
   Put (Integer'Image(Sim_Score));
   
end day1;

