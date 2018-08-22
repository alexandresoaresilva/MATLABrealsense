   function choice = choosedialog

        d = dialog('Position',[300 300 250 150],'Name','Select One');
        txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 40],...
               'String','take a picture of the macbeth checker');

        popup = uicontrol('Parent',d,...
               'Style','popup',...
               'Position',[75 70 100 25],...
               'String',{'Red';'Green';'Blue'},...
               'Callback',@popup_callback);

        btn = uicontrol('Parent',d,...
               'Position',[89 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');

        choice = 'Red';

        % Wait for d to close before running to completion
        %uiwait(d);

           function popup_callback(popup,event)
              idx = popup.Value;
              popup_items = popup.String;
              % This code uses dot notation to get properties.
              % Dot notation runs in R2014b and later.
              % For R2014a and earlier:
              % idx = get(popup,'Value');
              % popup_items = get(popup,'String');
              choice = char(popup_items(idx,:));
           end
    end