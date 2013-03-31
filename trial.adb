with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

with Ada.Calendar; use Ada.Calendar;

with Ada.Numerics.Float_Random; 
use Ada.Numerics.Float_Random; 


procedure sum_kernel  is

	package Fix_IO is new Ada.Text_IO.Fixed_IO(DAY_DURATION);
	use Fix_IO;

   	--type Range_Type is range 1 .. 100000;
	type vector1 is array (1 .. 650000) of FLOAT;
 	type vector2 is array (1 .. 650000) of FLOAT;
   	--package F_IO is new  Ada.Text_IO.Float_IO;
	a: vector1;
	b: vector1;
	c: vector1;

	d: vector2;
	e: vector2;
	f: vector2;

	G: Generator;
	H: Generator;
	--startTime: Clock;
	--endTime: Clock;

	Year,Month,Day : INTEGER;
	Time_And_Date  : TIME;
   	StartTime,EndTime  : DAY_DURATION;
	
	power: INTEGER;
	i: INTEGER;
	k : INTEGER;
	--elapsed: Time_Span;
begin
power:=1;

for j  in 1..5 loop

power := power * 50	;
Time_And_Date := Clock;
Split(Time_And_Date, Year, Month, Day, StartTime);

-- for i in power'Range loop
k:=1;
while k<10 loop
  i:=1;
  while i<power loop
      	a(i) := Random(G); 
	b(i) := Random(G);

	c(i) := a(i) + b(i);
	--Ada.Text_IO.Put (Item => Float'Image (c(i))) ;
        --Put_Line (", ");
	i:=i+1;
  end loop;
	k :=k+1;
end loop;

k:=1;
while k<10 loop
  i:=1;
  while i<power loop
      	d(i) := Random(H); 
	e(i) := Random(H);

	f(i) := d(i) + e(i);
	--Ada.Text_IO.Put (Item => Float'Image (c(i))) ;
       	 --Put_Line (", ");
	i:=i+1;
  end loop;
	k :=k+1;
end loop;

Time_And_Date := Clock;
Split(Time_And_Date, Year, Month, Day, EndTime);
Put(EndTime-StartTime);
end loop;
end sum_kernel;
