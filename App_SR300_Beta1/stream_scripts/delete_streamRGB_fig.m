function delete_streamRGB_fig(app, event)
    if  exist('app','class')
        if ~strcmp(app.timercolor{app.selectdev}.Running,'off')
            stop(app.timercolor{app.selectdev});
        end
        delete(app.figcolor{app.selectdev});
    end
end