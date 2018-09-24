# MATLABrealsense
3D camera(Intel SR300) paremeter setup app

![alt text](https://github.com/alexandresoaresilva/MATLABrealsense/blob/master/documentation/Capture.PNG)

color calibration: the capture with the camera doesn't have steps that follow it and make the RGB stream to crash. Lookign for a fix.

**compatibility(tested):** SR300

**platformt:** MATLAB's appdesigner

**authors:**

UX/functionalities: Alexandre Soares, Robert Kirkman;

stream timer scripts:  Ben Bryant;

color calibration: Dr. Hamed Sari-Sarraf (developed the automatic color checker detection algorithm), Alexandre Soares;

ivcam UI: Joel Reznick, Yousef Saed.

**Description:**
This app uses the previous (now deprecated) version of the Intel Realsense library. You don't need to install the SDK to use this app; just download the cloned repository it and double click the file MATLABRealsense.mlapp.

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
  -color calibration from camera capture (still not implemented fully)
ps: It carries Intel 3d RealSense libraries, licensed under Apache's 2.0 software license:
http://www.apache.org/licenses/LICENSE-2.0

The original C/C++ RealSense source files can be found here:
https://github.com/IntelRealSense/librealsense

Contributions to the UI (ivcam panels) and load/save parameters:

**Contributors' Repositories**

Yousef Saed: https://github.com/moosef-yousef/MATLABrealsense

Joel Reznick: https://github.com/bozingle/MATLABrealsense

Robert Kirkman: https://github.com/robertkirkman/MATLABrealsense
