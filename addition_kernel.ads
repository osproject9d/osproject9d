package sum_kernel is

function threadIdx_x return integer;
function blockIdx_x return integer;
function blockDim_x return integer;

pragma Import (C, threadIdx_x, "threadIdx_x");
pragma Import (C, blockIdx_x, "blockIdx_x");
pragma Import (C, blockDim_x, "blockDim_x");

--type vector is array (natural range <>) of float;
type vector is array (0..100) of float;
procedure sum_kernel (a, b : in vector; c: out vector);

pragma Export (C, sum_kernel, "sum_kernel");

end sum_kernel;
