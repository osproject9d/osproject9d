with Ada.Text_IO;
use Ada.Text_IO;
package body addition_kernel is

pragma suppress(range_check);


procedure addition_kernel (a, b : in vector; c: out vector) is

	idx: integer;

begin

	idx := threadIdx_x + blockIdx_x * blockDim_x;
	c(idx) := a(idx) + b(idx);

end addition_kernel;

end addition_kernel;
