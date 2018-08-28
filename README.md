# MATLABrealsense
3D camera(Intel SR300) paremeter setup app
compatibility(tested): SR300
platformt: MATLAB's appdesigner

Authors: 
UX/functionalities: Alexandre Soares, Robert Kirkman;
stream timer scripts:  Ben Bryant;
color calibration: Alexandre Soares, Dr. Hamed Sari-Sarraf (developed the automatic color checker detection algorithm);
ivcam UI: Joel Reznick, Yousef Saed.

This app uses the previous (now deprecated) version of the Intel Realsense library. You don't need to install the SDK to use this app; just download it and double click MATLABRealsense.mlapp.

1. Connect the camera before running MATLAB; 
2. run MATLAB as an adminstrator on Windows to use the app;

Capabilities:
  -set RGB parameters (brightness, contrast etc) settings
  -set depth parameters through Ivcam presets
  -saving the parameters set to a mat file
  -loading saved parameters back to the camera (including ivcam depth parameters)
  -RGB, depth, infrared, and point cloud (color projection onto depth) streams
  -color calibration with automatic detection of Macbeth color checker as target. It's based on Bastani and Funt's paper about normalized least-squares regression).

Near future planned features:
  -point cloud capture

ps: It carries Intel 3d RealSense libraries, licensed under Apache's 2.0 software license:
http://www.apache.org/licenses/LICENSE-2.0

The original C/C++ RealSense source files can be found here:
https://github.com/IntelRealSense/librealsense

Contributions to the UI (ivcam panels) and load/save parameters:

Repositories

Yousef Saed: https://github.com/moosef-yousef/MATLABrealsense

Joel Reznick: https://github.com/bozingle/MATLABrealsense

Robert Kirkman: https://github.com/robertkirkman/MATLABrealsense