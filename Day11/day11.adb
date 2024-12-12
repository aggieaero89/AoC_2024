-----------------------------------------------------------
-- Advent of Code 2024, Day 11
-----------------------------------------------------------
with Ada.Text_IO; use Ada.Text_IO;
with GNAT.String_Split; use GNAT.String_Split;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure day11 is

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

   Tokens : Slice_Set;
   package Integer_Vectors is new Ada.Containers.Vectors(Positive,Long_Long_Integer);
   subtype Vector is Integer_Vectors.Vector;
   use all type Vector;
   package Vec_Sorting is new Integer_Vectors.Generic_Sorting;
   V : Vector;

   Knt, Num_Blinks, Add_Blinks : Integer;
   Total_Num, Subtotal_Num : Long_Long_Integer;

   type Point is record
      Val : Long_Long_Integer;
      Num : Long_Long_Integer;
   end record;

   package Point_Vectors is new Ada.Containers.Vectors(Positive,Point);
   subtype Points is Point_Vectors.Vector;
   P : Point;
   P_Vec : Points;
   First_Time : Boolean;

   function Blink(V_in : Vector) return Vector is
      V_out : Vector;
      Build_String : Unbounded_String;
      Mid, Len, Fi, La : Integer;
   begin
      for I of V_in loop
         Build_String := Null_Unbounded_String;
         Append(Build_String, Long_Long_Integer'Image(I)(2..Long_Long_Integer'Image(I)'Last));
         if To_String(Build_String) = "0" then
            V_out.Append(1);
         elsif To_String(Build_String)'Length mod 2 = 0 then
            Len := To_String(Build_String)'Length;
            Mid := Len/2;
            Fi := To_String(Build_String)'First;
            La := To_String(Build_String)'Last;
            V_out.Append(Long_Long_Integer'Value(To_String(Build_String)(Fi .. Fi+Mid-1)));
            V_out.Append(Long_Long_Integer'Value(To_String(Build_String)(Fi+Mid .. La)));
         else
            V_out.Append(2024*I);
         end if;

      end loop;

      return V_out;

   end Blink;

   function Blink(I_in : Long_Long_Integer) return Vector is
      V_in : Vector;
   begin
      V_in.Append(I_in);
      return Blink(V_in);
   end Blink;

begin
   Open (F, In_File, FName);
   Create (Tokens, Get_Line(F), " ", Multiple);
   Close (F);

   Put("For Part 1, how many times you blinked? <For Part 2, enter 37> "); Num_Blinks := Integer'Value(Get_Line);
   Put("For Part 2, how many additional blinks? <for Part 2, enter 38> "); Add_Blinks := Integer'Value(Get_Line);
   
   for I in 1 .. Slice_Count (Tokens) loop
      V.Append(Long_Long_Integer'Value(Slice(Tokens,I)));
   end loop;

   Knt := 0;
   while Knt < Num_Blinks loop
      V := Blink(V);
      Knt := Knt + 1;
   end loop;

   Total_Num := 0;
   for I of V loop
      Total_Num := Total_Num + 1;
   end loop;

   New_Line;
   Put_Line ("*** Day 11, Part 1 *** ");
   Put ("Number of stones after blinking " & integer'image(Num_Blinks) & " times is: ");
   Put (Long_Long_Integer'Image(Total_Num));
   New_Line(2);

   Vec_Sorting.Sort(V);
   Total_Num := 0;
   First_Time := True;
   for I of V loop
      if First_Time then
         P.Val := I;
         P.Num := 1;
         First_Time := False;
      else
         if P.Val /= I then
            P_Vec.Append(P);
            P.Val := I;
            P.Num := 1;
         else
            P.Num := P.Num + 1;
         end if;

      end if;
      Total_Num := Total_Num + 1;
   end loop;
   P_Vec.Append(P);

   Create (F, Out_File, "Sorted.txt");
   for I of P_Vec loop
      Put(F, Long_Long_Integer'Image(I.Val));
      Put_Line(F, Long_Long_Integer'Image(I.Num));
   end loop;
   Close (F);

   Total_Num := 0;
   for I of P_Vec loop
      V := Blink(I.Val);
      Knt := 1;
      while Knt < Add_Blinks loop
         V := Blink(V);
         Knt := Knt + 1;
      end loop;

      Subtotal_Num := 0;
      for J of V loop
         Subtotal_Num := Subtotal_Num + 1;
      end loop;

      Total_Num := Total_Num + Subtotal_Num * I.Num;

   end loop;

   New_Line;
   Put_Line ("*** Day 11, Part 2 *** ");
   Put ("Number of stones after blinking " & integer'image(Num_Blinks+Add_Blinks) & " times is: ");
   Put (Long_Long_Integer'Image(Total_Num));
   New_Line(2);


end day11;

