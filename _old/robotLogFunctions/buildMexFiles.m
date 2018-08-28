clc
mex(['-I', pwd, filesep], 'rs_transform_point_to_point_Mex.c', '-v')
mex(['-I', pwd, filesep], 'rs_project_point_to_pixel_Mex.c', '-v')
mex(['-I', pwd, filesep], 'rs_deproject_pixel_to_point_Mex.c', '-v')

% mex(['-I', pwd, filesep], 'make_rs_mexCallback.cpp', '-v')
