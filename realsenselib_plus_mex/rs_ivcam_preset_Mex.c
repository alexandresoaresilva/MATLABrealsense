/*ivcam prest librealsense function in C for matlab mex, following Ben Bryant convention*/
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <windows.h>
#include <process.h>
/*realsense, matlab mex and debug headers*/
#include <rs.h>
#include <rsutil.h>
#include <assert.h>
#include <mex.h>

/*struct definition and global instance for converting preset name to rs.h rs_ivcam_preset enum*/
struct ivcam_preset_conversion_struct
{
	rs_ivcam_preset ivcam_preset_val;
	const char *ivcam_preset_str;
};
typedef struct ivcam_preset_conversion_struct ivcam_preset_conversion_struct;

const static ivcam_preset_conversion_struct ivcam_preset_conversion[11] =
{
	{RS_IVCAM_PRESET_SHORT_RANGE, "RS_IVCAM_PRESET_SHORT_RANGE"},
	{RS_IVCAM_PRESET_LONG_RANGE, "RS_IVCAM_PRESET_LONG_RANGE"},
	{RS_IVCAM_PRESET_BACKGROUND_SEGMENTATION, "RS_IVCAM_PRESET_BACKGROUND_SEGMENTATION"},
	{RS_IVCAM_PRESET_GESTURE_RECOGNITION, "RS_IVCAM_PRESET_GESTURE_RECOGNITION"},
	{RS_IVCAM_PRESET_OBJECT_SCANNING, "RS_IVCAM_PRESET_OBJECT_SCANNING"},
	{RS_IVCAM_PRESET_FACE_ANALYTICS, "RS_IVCAM_PRESET_FACE_ANALYTICS"},
	{RS_IVCAM_PRESET_FACE_LOGIN, "RS_IVCAM_PRESET_FACE_LOGIN"},
	{RS_IVCAM_PRESET_GR_CURSOR, "RS_IVCAM_PRESET_GR_CURSOR"},
	{RS_IVCAM_PRESET_DEFAULT, "RS_IVCAM_PRESET_DEFAULT"},
	{RS_IVCAM_PRESET_MID_RANGE, "RS_IVCAM_PRESET_MID_RANGE"},
	{RS_IVCAM_PRESET_IR_ONLY, "RS_IVCAM_PRESET_IR_ONLY"}
};

/*function to convert string to rs_ivcam_preset, default if no match*/
rs_ivcam_preset convert_ivcam_preset(const char *ivcam_preset_str)
{
	for (int i = 0; i < 11; i++)
		if (!strcmp(ivcam_preset_str, ivcam_preset_conversion[i].ivcam_preset_str))
			return ivcam_preset_conversion[i].ivcam_preset_val;
	return ivcam_preset_conversion[8].ivcam_preset_val;
}

/*mex function to pass values to rs_apply_ivcam_preset()*/
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	if(nrhs != 2)
		mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs", "Two inputs required.");
	
	/*check that number of rows in second input argument is 1*/
	if(mxGetM(prhs[1]) != 1)
		mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notRowVector", "Input must be a row vector.");
	
	if(!mxIsChar(prhs[1]))
		mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notChar", "Input matrix must be type char.");
	
	/*get and convert ivcam_preset_str*/
	const char *ivcam_preset_str = (char *)mxGetData(prhs[1]);
	rs_ivcam_preset ivcam_preset = convert_ivcam_preset(ivcam_preset_str);
	
	/*how to pass rs_device (connected camera to set presets on) as element of mxArray *prhs[]?)*/
	const rs_device *dev = prhs[0];
	
	/*call realsense function to change ivcam preset*/
	rs_apply_ivcam_preset(dev, ivcam_preset); 
	
	return;
}