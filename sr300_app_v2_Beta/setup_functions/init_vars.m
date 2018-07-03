        function init_vars(app)
            app.opt = 0; %starts with Contrast
            app.width = 640; 
            app.height = 480;
            app.fps = 30;
            %app.ardobj = arduino;
            %app.axis1 = servo(app.ardobj,'D2');
            %app.axis2 = servo(app.ardobj,'D3');
            
            loadlibrary('realsense.dll', 'rsutil.h', ...
                        'addheader','rs.h', ...
                        'mfilename', 'realsense');
            [app.methodinfo, app.structs, app.rsEnum, app.ThunkLibName] = realsense;
            [app.ctx, app.err] = calllib('realsense', 'rs_create_context', 11201, rs_error);
            rs_check_error(app.err);
            %new code to get number of cameras connected and make device objects and initialize each
            [app.deviceCount, app.err] = calllib('realsense', 'rs_get_device_count', app.ctx, rs_error());
            rs_check_error(app.err);
            for i = 1:app.deviceCount
                app.devIdx = i - 1;
                [app.dev{i}, app.err] = calllib('realsense', 'rs_get_device', app.ctx, app.devIdx, rs_error);
                rs_check_error(app.err);
                [app.deviceFriendlyName{i}, app.err] = calllib('realsense', 'rs_get_device_name', app.dev{i}, rs_error());
                rs_check_error(app.err);
                [~, app.err] = calllib('realsense', 'rs_enable_stream', app.dev{i}, app.rsEnum.rs_stream.RS_STREAM_COLOR, ...
                    app.width, app.height, app.rsEnum.rs_format.RS_FORMAT_RGB8, app.fps, rs_error);
                rs_check_error(app.err);
                [~, app.err] = calllib('realsense', 'rs_enable_stream', app.dev{i}, app.rsEnum.rs_stream.RS_STREAM_DEPTH, ...
                    app.width, app.height, app.rsEnum.rs_format.RS_FORMAT_Z16, app.fps, rs_error);
                rs_check_error(app.err);
                [~, app.err] = calllib('realsense', 'rs_start_device', app.dev{i}, rs_error);
                rs_check_error(app.err);
                
                app.depth_intrin{i} = libstruct('rs_intrinsics', struct());
                
                [~, app.depth_intrin{i}, app.err] = calllib('realsense', 'rs_get_stream_intrinsics', ...
                    app.dev{i}, app.rsEnum.rs_stream.RS_STREAM_DEPTH, app.depth_intrin{i}, rs_error);
                rs_check_error(app.err);
                
                app.color_intrin{i} = libstruct('rs_intrinsics', struct());
                [~, app.color_intrin{i}, app.err] = calllib('realsense', 'rs_get_stream_intrinsics', ...
                    app.dev{i}, app.rsEnum.rs_stream.RS_STREAM_COLOR, app.color_intrin{i}, rs_error);
                rs_check_error(app.err);
                
                app.depth_to_color{i} = libstruct('rs_extrinsics', struct());
                [~, app.depth_to_color{i}, app.err] = calllib('realsense', 'rs_get_device_extrinsics', ...
                    app.dev{i}, app.rsEnum.rs_stream.RS_STREAM_DEPTH, app.rsEnum.rs_stream.RS_STREAM_COLOR, app.depth_to_color{i}, rs_error);
                rs_check_error(app.err);
                
                [app.scale{i}, app.err] = calllib('realsense', 'rs_get_device_depth_scale', app.dev{i}, rs_error);
                rs_check_error(app.err);
            end
            app.selectdev = 1;
            app.index = 1;
            getCamShortName(app);%separates the camera nickname ("SR300", for ex) from human-friendly name
            %initialize variables for ivcam presets
            app.ivcamopts = [18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 12, 13, 15, 16, 14];
            app.ivcampresets = load('ivcampresets.mat'); 
            %app.ivcamoptvals = app.ivcampresets.ivcampresets(1)
            %initialize stream snapshot variables
            app.countcolor = 0;
            app.countdepth = 0;
            app.countpcl = 0;
            
            %timers for stream display scripts
            app.timercolor = timer('TimerFcn', @(x, y) color(app, x, y), 'ExecutionMode', 'fixedRate', 'Period', 1/30, 'Name', 'timercolor');
            app.timerdepth = timer('TimerFcn', @(x, y) depth(app, x, y), 'ExecutionMode', 'fixedRate', 'Period', 1/30, 'Name', 'timerdepth');
            app.timerpcl = timer('TimerFcn', @(x, y) pcl(app, x, y), 'ExecutionMode', 'fixedRate', 'Period', 1/30, 'Name', 'timerpcl');
            app.timerall = timer('TimerFcn', @(x, y) allcam(app, x, y), 'ExecutionMode', 'fixedRate', 'Period', 1/30, 'Name', 'timerall');

            %hide figure 1
            set(figure(1),'Visible','off');
            drawnow;
            
            %load calibration coordinates
            %testAndChangePathIfNeeded(app); %changes folder if it's not the app's and adds colorcalibration folder
            
            app.colorcoords = load('colorcoords.mat');
        end
%>>>>>>>>> END of initializeVariables
