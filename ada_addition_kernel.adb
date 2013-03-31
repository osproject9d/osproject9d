with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

with Ada.Calendar; use Ada.Calendar;

with Ada.Numerics.Float_Random; 
use Ada.Numerics.Float_Random; 


procedure sum_kernel  is

	package Fix_IO is new Ada.Text_IO.Fixed_IO(DAY_DURATION);
	use Fix_IO;

   	type Range_Type is range 1 .. 1000;
	type vector is array (Range_Type) of float;

   	--package F_IO is new  Ada.Text_IO.Float_IO;
	a: vector;
	b: vector;
	c: vector;

	G: Generator;
	--startTime: Clock;
	--endTime: Clock;

	Year,Month,Day : INTEGER;
	Time_And_Date  : TIME;
   	StartTime,EndTime  : DAY_DURATION;
	
	power: Range_Type;
	i: Range_Type;
	--elapsed: Time_Span;
begin
power:=1;

for j  in 1..5 loop

power := power * 10;
Time_And_Date := Clock;
Split(Time_And_Date, Year, Month, Day, StartTime);

-- for i in power'Range loop
  i:=1;
  while i<power loop
      	a(i) := Random(G); 
	b(i) := Random(G);

	c(i) := a(i) + b(i);
	--Ada.Text_IO.Put (Item => Float'Image (c(i))) ;
        --Put_Line (", ");
	i:=i+1;
  end loop;
Time_And_Date := Clock;
Split(Time_And_Date, Year, Month, Day, EndTime);
Put(EndTime-StartTime);
end loop;
end sum_kernel;
