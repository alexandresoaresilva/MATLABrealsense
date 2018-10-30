function buildAvailabCamParamList(app) %script for getting all parameters(app)

    % get device options list
    rsoptions = fieldnames(app.rsEnum.rs_option);
    rsoptionscount = numel(rsoptions);
   
    optsupported = cell(rsoptionscount, 1);
    paramOPTtabCount = cell(rsoptionscount,1);
    supportedConnectedCam = cell(rsoptionscount,1);
    parameterNicerName = cell(rsoptionscount,1);
    dev_opt_desc = cell(rsoptionscount,1);
    paramCallName = cell(rsoptionscount,1);
    
    dev_opt_current = zeros(rsoptionscount, 1);
    opt_min = zeros(rsoptionscount, 1);
    opt_max = zeros(rsoptionscount, 1);
    opt_step = zeros(rsoptionscount, 1);
    opt_default = zeros(rsoptionscount, 1);
    
    
    app.selCamOptTable = struct;
    
    %gets supported options by camera
    
    for a=1:app.deviceCount
        
        for i = 1:rsoptionscount
            option = app.rsEnum.rs_option.(rsoptions{i});

            [optsupportedDummy, ~, app.err] = calllib('realsense', 'rs_device_supports_option',...
                    app.dev{a}, option, rs_error);
                rs_check_error(app.err);

            if  optsupportedDummy%only saves supported options for camera
                paramCallName{i} = rsoptions{i};
                parameterNicerName(i) = tokParamName(rsoptions(i));
                paramOPTtabCount{i}= i;
                supportedConnectedCam(i) = app.connctdShortCamNames(a);

                [optsupported{i}, ~, app.err] = calllib('realsense', 'rs_device_supports_option',...
                    app.dev{a}, option, rs_error);
                rs_check_error(app.err);

                [dev_opt_desc{i}, ~, app.err] = calllib('realsense',...
                     'rs_get_device_option_description', app.dev{a}, option, rs_error);
                 rs_check_error(app.err);

                [dev_opt_current(i), ~, app.err] = calllib('realsense',...
                    'rs_get_device_option', app.dev{a}, option, rs_error);
                rs_check_error(app.err); %gets current value

                [~,  opt_min(i), opt_max(i), opt_step(i), opt_default(i), app.err] = calllib('realsense',...
                    'rs_get_device_option_range_ex', app.dev{a}, option, ...
                     opt_min(i), opt_max(i), opt_step(i), opt_default(i),rs_error);
                rs_check_error(app.err);
            end
        end
      %1. paramOPTtabCount = indexes from the full list of parameters.
      %useful when dealing with parameters not shown on the listbox (for
      %retrieving values)
      %2. supportedConnectedCam = 'SR300', 'F200'
      %3. paramCallName = parameter as passed to camera's functions
      %4. parameterNicerName = just lower case name, without rs_option
      %5. dev_opt_desc  = paramteter's description
      %6. dev_opt_current = paramterer's current value
      %7. opt_min  = minimum value for the parameter
      %8. opt_default = self-explanatory
      %9. opt_max =  max value for the parameter
      %10. opt_step = parameter step size (only changes for white balance)
      %11. opt_supported{i} = if it is supported by the selected camera or
      %not

      paramOPTtab = [paramOPTtabCount, supportedConnectedCam,...
          paramCallName, parameterNicerName,...
          dev_opt_desc, num2cell(dev_opt_current), num2cell(opt_min),...
          num2cell(opt_default), num2cell(opt_max), num2cell(opt_step)];

         dummyOptTable=cell(1,length(paramOPTtab(1,:))); 
         %one line of the options table, cell array

         j=1;
         for i = 1:length(paramOPTtab)%gets rid of empty rows
           if ~isempty(paramOPTtab{i,1})
               dummyOptTable(j,:) = paramOPTtab(i,:);
               j=j+1;
           end
         end
        %cams name to be struc field
        field = char(strcat(app.connctdShortCamNames{a},strcat('_',string(a)))); 

        [app.selCamOptTable(:).(field)] = deal(dummyOptTable); %saves
        
%         fileName = 'optionsTableTest';
%         fileExists_question = exist('optionsTableTest');
%         
%         
%         save('optionsTable','app.selCamOptTable');
    end %end of loop that runs through connected camera list 
 %fieldnames(app.selCamOptTabl
     
     %dummyOptTable;
     %app.selCamOptTable
end

function paramFriendlyName = tokParamName(title) %removes RS and OPTION and transforms parameter friendly name
    tokenizedName = string;
    [token,remain]=strtok(char(title),'_');
    tokenizedName(end)=token;

    for i=1:length(remain)
        if ~isempty(remain)
            [token,remain]=strtok(remain,'_');
             tokenizedName(end+1) = token;
        end
    end

    %next clears name
    tokenizedName = tokenizedName(tokenizedName~='RS');
    tokenizedName = tokenizedName(tokenizedName~='OPTION');
    tokenizedName = lower(tokenizedName);
    paramFriendlyName=tokenizedName(1);
    for i=2:length(tokenizedName)
        paramFriendlyName = strcat(paramFriendlyName,{' '});
        paramFriendlyName = strcat(paramFriendlyName,tokenizedName(i));
    end
    paramFriendlyName = cellstr(paramFriendlyName);
end