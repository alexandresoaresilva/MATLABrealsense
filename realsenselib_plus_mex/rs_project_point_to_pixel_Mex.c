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

const static struct {
	rs_distortion      val;
	const char *str;
} conversion[] = {
	{ RS_DISTORTION_NONE, "RS_DISTORTION_NONE" },
	{ RS_DISTORTION_MODIFIED_BROWN_CONRADY, "RS_DISTORTION_MODIFIED_BROWN_CONRADY" },
	{ RS_DISTORTION_INVERSE_BROWN_CONRADY, "RS_DISTORTION_INVERSE_BROWN_CONRADY" },
	{ RS_DISTORTION_FTHETA, "RS_DISTORTION_FTHETA" },
	{ RS_DISTORTION_COUNT, "RS_DISTORTION_COUNT" },
};

rs_distortion str2enum(const char *str)
{
	//int j;
    mwSize j;
    //mwSize
	for (j = 0; j < sizeof(conversion) / sizeof(conversion[0]); ++j)
		if (!strcmp(str, conversion[j].str))
			return conversion[j].val;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
    const mxArray *pointsMx = prhs[0];
	const mxArray *intrinMx = prhs[1];

	__int32 numelPts = mxGetN(pointsMx);
	if (mxGetM(pointsMx) != 3) { mexErrMsgTxt("points must have 3 columns"); return; }

	float *points;
	if (mxIsClass(pointsMx, "single")) {
		points = (float*)mxGetData(pointsMx);
	} 
	else if (mxIsClass(pointsMx, "double")) {
		double *ptsDouble = (double*)mxGetData(pointsMx);
		points = (float*)malloc(numelPts * 3 * sizeof(double));
		for (int i = 0; i < numelPts * 3; i++) {
			points[i] = (float)ptsDouble[i];
		}
	}
	else {
		mexErrMsgTxt("points must be single or double"); 
		return; 
	}

	plhs[0] = mxCreateNumericMatrix(2, numelPts, mxSINGLE_CLASS, mxREAL);
	float *pixels = (float*)mxGetData(plhs[0]);

	rs_intrinsics intrin;

	int nfields = mxGetNumberOfFields(intrinMx);
	int NStructElems = mxGetNumberOfElements(intrinMx);
	if (NStructElems != 1) { mexErrMsgTxt("intrin should be an array with 1 element"); return; }

	for (int ifield = 0; ifield < nfields; ifield++) {
		const char *fname = mxGetFieldNameByNumber(intrinMx, ifield);
		const mxArray *temp = mxGetFieldByNumber(intrinMx, 0, ifield);
		if (!strcmp(fname, "width")) {
			intrin.width = (int)mxGetScalar(temp);
		}
		else if (!strcmp(fname, "height")) {
			intrin.height = (int)mxGetScalar(temp);
		}
		else if (!strcmp(fname, "ppx")) {
			intrin.ppx = (float)mxGetScalar(temp);
		}
		else if (!strcmp(fname, "ppy")) {
			intrin.ppy = (float)mxGetScalar(temp);
		}
		else if (!strcmp(fname, "fx")) {
			intrin.fx = (float)mxGetScalar(temp);
		}
		else if (!strcmp(fname, "fy")) {
			intrin.fy = (float)mxGetScalar(temp);
		}
		else if (!strcmp(fname, "model")) {
			char buff[500];
			mxGetString(temp, buff, 500);
			intrin.model = str2enum(buff);
		}
		else if (!strcmp(fname, "coeffs")) {
			float *dArray = (float*)mxGetPr(temp);
			if (mxGetN(temp) != 5) { mexErrMsgTxt("intrin coeff must have 5 elements"); return; }
			for (int i = 0; i < 5; i++) {
				intrin.coeffs[i] = dArray[i];
			}
		}
	}

	for (int i = 0; i < numelPts; i++) {
		rs_project_point_to_pixel(&pixels[2*i], &intrin, &points[3*i]);
	}
	if (mxIsClass(pointsMx, "double")) {
		free(points);
	}

}

