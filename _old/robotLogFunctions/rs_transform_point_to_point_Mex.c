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

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
	const mxArray *depthPointsMxMx = prhs[0];
	const mxArray *extrinMx = prhs[1];

	__int32 numelPts = mxGetN(depthPointsMxMx);
	if (mxGetM(depthPointsMxMx) != 3) { mexErrMsgTxt("depthPointsMx must have 3 columns"); return; }

	float *depthPointsMx;
	if (mxIsClass(depthPointsMxMx, "single")) {
		depthPointsMx = (float*)mxGetData(depthPointsMxMx);
	}
	else if (mxIsClass(depthPointsMxMx, "double")) {
		double *ptsDouble = (double*)mxGetData(depthPointsMxMx);
		depthPointsMx = (float*)malloc(numelPts * 3 * sizeof(double));
		for (int i = 0; i < numelPts * 3; i++) {
			depthPointsMx[i] = (float)ptsDouble[i];
		}
	}
	else {
		mexErrMsgTxt("depthPointsMx must be single or double");
		return;
	}

	plhs[0] = mxCreateNumericMatrix(3, numelPts, mxSINGLE_CLASS, mxREAL);
	float *colorPoints = (float*)mxGetData(plhs[0]);

	rs_extrinsics extrin;

	int nfields = mxGetNumberOfFields(extrinMx);
	int NStructElems = mxGetNumberOfElements(extrinMx);
	if (NStructElems != 1) { mexErrMsgTxt("extrin should be an array with 1 element"); return; }

	for (int ifield = 0; ifield < nfields; ifield++) {
		const char *fname = mxGetFieldNameByNumber(extrinMx, ifield);
		const mxArray *temp = mxGetFieldByNumber(extrinMx, 0, ifield);
		if (!strcmp(fname, "rotation")) {
			float *dArray = (float*)mxGetPr(temp);
			if (mxGetN(temp)*mxGetM(temp) != 9) { mexErrMsgTxt("extrin coeff must have 9 elements"); return; }
			for (int i = 0; i < 9; i++) {
				extrin.rotation[i] = dArray[i];
			}
		}
		else if (!strcmp(fname, "translation")) {
			float *dArray = (float*)mxGetPr(temp);
			if (mxGetN(temp)*mxGetM(temp) != 3) { mexErrMsgTxt("extrin coeff must have 3 elements"); return; }
			for (int i = 0; i < 3; i++) {
				extrin.translation[i] = dArray[i];
			}
		}
	}

	for (int i = 0; i < numelPts; i++) {
		rs_transform_point_to_point(&colorPoints[3 * i], &extrin, &depthPointsMx[3 * i]);
	}
	if (mxIsClass(depthPointsMxMx, "double")) {
		free(depthPointsMx);
	}

}

