with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

with Ada.Calendar; use Ada.Calendar;

with Ada.Numerics.Float_Random; 
use Ada.Numerics.Float_Random; 


procedure sum_kernel2  is

	package Fix_IO is new Ada.Text_IO.Fixed_IO(DAY_DURATION);
	use Fix_IO;

   	type Range_Type is range 1 .. 600;
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
	
	power: integer;
	i: integer;
	k: integer;
	j: integer;
	--elapsed: Time_Span;
begin

k:=1;
power:=1;
while k<10 loop
	Time_And_Date := Clock;
	Split(Time_And_Date, Year, Month, Day, StartTime);

	j:=1;
	power:=power*10;
	while j<power loop
		i:=1;
		for i in Range_Type loop
      			a(i) := Random(G); 
			b(i) := Random(G);
			c(i) := a(i) + b(i);
		end loop;
		j:=j+1;
	end loop;
	k:=k+1;
	Time_And_Date := Clock;
	Split(Time_And_Date, Year, Month, Day, EndTime);
	Put(EndTime-StartTime);
end loop;

end sum_kernel2;
