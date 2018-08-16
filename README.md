# MATLABrealsense
3D camera(Intel SR300) paremeter setup app
compatibility(tested): SR300
platformt: MATLAB's appdesigner

1. Connect the camera before running MATLAB; 
2. run MATLAB as an adminstrator on Windows to use the app;

There are two implementations in MATLAB for sr300 cameras. V_2 doesn't work yet.
The two folders:
  1. App_SR300_Beta1 - this is the working version;
  2. sr300_app_v2_Beta - this is the start of a rewritten version.

The first, App_SR300_Beta1, is being organized and fixed for submission to Mathworks. It offers for now:
Capabilities:
  -set RGB parameters (brightness, contrast etc) settings
  -set depth parameters through Ivcam presets
  -saving the parameters set to a mat file
  -RGB, depth, and point cloud (color projection onto depth) streams

Near future planned features:
  -access to infrared stream
  -loading saved RGB parameters into camera (the button is there, but it doesn't work properly)
  -color calibration using Macbeth color checker - the script is there, based on Bastani and Funt's paper
  about normalized least-squares regression, but it's not integrated into the app's GUI. the script that is triggered
  with the color calibration button doesn't work for non-uniform ilumination.
  -point cloud capture
  -other smaller fixes to GUI


ps: It carries Intel 3d RealSense libraries, licensed under Apache's 2.0 software license:
http://www.apache.org/licenses/LICENSE-2.0

The original C/C++ RealSense source files can be found here:
https://github.com/IntelRealSense/librealsense

Contributions to the UI (ivcam panels) and load/save parameters:
https://github.com/moosef-yousef/MATLABrealsense
https://github.com/bozingle/MATLABrealsense



