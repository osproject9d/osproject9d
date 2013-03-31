#include "llvm/TypeBuilder.h"
#include "llvm/Pass.h"
#include "llvm/Function.h"
#include "llvm/Module.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_os_ostream.h"

using namespace llvm;
using namespace std;

class CudaAda : public ModulePass
{
public:
	static char ID;

	CudaAda() : ModulePass(ID) { }
	
	virtual bool runOnModule(Module &m) {

		LLVMContext& context = m.getContext();

		// Insert llvm ptx intrinsics definitions.
		Function* llvm_ptx_read_tid_x = Function::Create(
			TypeBuilder<types::i<32>(), true>::get(context),
			GlobalValue::ExternalLinkage, "llvm.ptx.read.tid.x", &m);
		Function* llvm_ptx_read_ntid_x = Function::Create(
			TypeBuilder<types::i<32>(), true>::get(context),
			GlobalValue::ExternalLinkage, "llvm.ptx.read.ntid.x", &m);
		Function* llvm_ptx_read_ctaid_x = Function::Create(
			TypeBuilder<types::i<32>(), true>::get(context),
			GlobalValue::ExternalLinkage, "llvm.ptx.read.ctaid.x", &m);

		// For each function:
		// if its name ends with _kernel, then mark it as CUDA kernel.
		// if its name ends with _device, then mark it as CUDA device function.
		// otherwise, remove it.
		string kernel_suffix = "_kernel";
		string device_suffix = "_device";
		vector<Function*> erase;
		for (Module::iterator f = m.begin(), fe = m.end(); f != fe; f++) {
			string name = f->getName();

			if (name == "llvm.ptx.read.tid.x") continue;
			if (name == "llvm.ptx.read.ntid.x") continue;
			if (name == "llvm.ptx.read.ctaid.x") continue;

			if (name.length() >= kernel_suffix.length())
				if (name.compare(name.length() - kernel_suffix.length(),
					kernel_suffix.length(), kernel_suffix) == 0)
				{
					f->setCallingConv(CallingConv::PTX_Kernel);
					continue;
				}
			if (name.length() >= device_suffix.length())
				if (name.compare(name.length() - device_suffix.length(),
					device_suffix.length(), device_suffix) == 0)
				{
					f->setCallingConv(CallingConv::PTX_Device);
					continue;
				}

			// Replace particular Ada functions with intrinsics.
			if (name == "threadIdx_x")
				f->replaceAllUsesWith(llvm_ptx_read_tid_x);
			if (name == "blockIdx_x")
				f->replaceAllUsesWith(llvm_ptx_read_ntid_x);
			if (name == "blockDim_x")
				f->replaceAllUsesWith(llvm_ptx_read_ctaid_x);

			erase.push_back(f);
		}
		for (vector<Function*>::iterator i = erase.begin(), e = erase.end(); i != e; i++)
			(*i)->eraseFromParent();
		
		while (m.global_begin() != m.global_end())
			m.global_begin()->eraseFromParent();

		return true;
	}
};

char CudaAda::ID = 0;

static RegisterPass<CudaAda> A("cudada", "Mark CUDA kernels and bind intrinsics for Ada-generated LLVM IR");

Pass* createCudaAdaPass()
{
	return new CudaAda();
}

