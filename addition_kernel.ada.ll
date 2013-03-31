; ModuleID = 'sum_kernel.adb'
target datalayout = "e-p:64:64:64-S128-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f16:16:16-f32:32:32-f64:64:64-f128:128:128-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

module asm "\09.ident\09\22GCC: (GNU) 4.6.4 20130214 (prerelease) LLVM: 3.2svn\22"

%struct.sum_kernel__TvectorB___XUP = type { [0 x float]*, %struct.sum_kernel__TvectorB___XUB* }
%struct.sum_kernel__TvectorB___XUB = type { i32, i32 }

@sum_kernel_E = unnamed_addr global i8 0

define void @sum_kernel__TvectorBIP(i64 %_init.0, i64 %_init.1) unnamed_addr uwtable inlinehint {
entry:
  %_init_addr = alloca %struct.sum_kernel__TvectorB___XUP, align 16
  %"alloca point" = bitcast i32 0 to i32
  %0 = bitcast %struct.sum_kernel__TvectorB___XUP* %_init_addr to { i64, i64 }*
  %1 = getelementptr inbounds { i64, i64 }* %0, i32 0, i32 0
  store i64 %_init.0, i64* %1, align 1
  %2 = bitcast %struct.sum_kernel__TvectorB___XUP* %_init_addr to { i64, i64 }*
  %3 = getelementptr inbounds { i64, i64 }* %2, i32 0, i32 1
  store i64 %_init.1, i64* %3, align 1
  %"ssa point" = bitcast i32 0 to i32
  br label %"2"

"2":                                              ; preds = %entry
  br label %return

return:                                           ; preds = %"2"
  ret void
}

define void @sum_kernel(float* %a, float* %b, float* %c) unnamed_addr uwtable {
entry:
  %a_addr = alloca float*, align 8
  %b_addr = alloca float*, align 8
  %c_addr = alloca float*, align 8
  %idx = alloca i32
  %"alloca point" = bitcast i32 0 to i32
  store float* %a, float** %a_addr, align 1
  store float* %b, float** %b_addr, align 1
  store float* %c, float** %c_addr, align 1
  %0 = load float** %a_addr, align 8
  %1 = load float** %b_addr, align 8
  %2 = load float** %c_addr, align 8
  %"ssa point" = bitcast i32 0 to i32
  br label %"2"

"2":                                              ; preds = %entry
  %3 = call i32 @threadIdx_x()
  %4 = call i32 @blockIdx_x()
  %5 = call i32 @blockDim_x()
  %6 = mul i32 %4, %5
  %7 = add i32 %3, %6
  %8 = sext i32 %7 to i64
  %9 = sext i32 %7 to i64
  %10 = bitcast float* %0 to [101 x float]*
  %11 = bitcast [101 x float]* %10 to float*
  %12 = getelementptr float* %11, i64 %9
  %13 = load float* %12, align 4
  %14 = sext i32 %7 to i64
  %15 = bitcast float* %1 to [101 x float]*
  %16 = bitcast [101 x float]* %15 to float*
  %17 = getelementptr float* %16, i64 %14
  %18 = load float* %17, align 4
  %19 = fadd float %13, %18
  %20 = bitcast float* %2 to [101 x float]*
  %21 = bitcast [101 x float]* %20 to float*
  %22 = getelementptr float* %21, i64 %8
  store float %19, float* %22, align 4
  br label %return

return:                                           ; preds = %"2"
  ret void
}

declare i32 @threadIdx_x()

declare i32 @blockIdx_x()

declare i32 @blockDim_x()
