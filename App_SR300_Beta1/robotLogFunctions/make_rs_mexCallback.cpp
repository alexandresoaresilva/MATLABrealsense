#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <windows.h>
#include <process.h>
#include <rs.h>
#include <rsUtil.h>
#include <assert.h>
#include <mex.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
//    const mxArray *pointsMx = prhs[0];
//	const mxArray *intrinMx = prhs[1];


 //   int mexCallMATLAB(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[], const char *functionName);
    
 //   void mexMakeMemoryPersistent(void *ptr);
    
    void * depth_callback = [depth_intrin, depth_format](rs::frame f)
    {
        std::cout << depth_intrin.width << "x" << depth_intrin.height
            << " " << depth_format << "\tat t = " << f.get_timestamp() << " ms" << std::endl;
    };
    
    auto depth_callback = [depth_intrin, depth_format](rs::frame f)
    {
        std::cout << depth_intrin.width << "x" << depth_intrin.height
            << " " << depth_format << "\tat t = " << f.get_timestamp() << " ms" << std::endl;
    };
    auto color_callback = [color_intrin, color_format](rs::frame f)
    {
        std::cout << color_intrin.width << "x" << color_intrin.height
            << " " << color_format << "\tat t = " << f.get_timestamp() << " ms" << std::endl;
    };
    
	plhs[0] = mxCreateNumericMatrix(2, 1, mxUINT64_CLASS, mxREAL);
	uint64 *callbacks = (float*)mxGetData(plhs[0]);
    callbacks[0] = depth_callback;
    callbacks[1] = color_callback;
    
}














