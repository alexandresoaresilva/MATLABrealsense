function delete_streamRGB_fig(app, event)
    if  isvalid(app)
        if  isvalid(app.timercolor{app.selectdev})
            if ~strcmp(app.timercolor{app.selectdev}.Running,'off')
                stop(app.timercolor{app.selectdev});
            end
            if isvalid(app.figcolor{app.selectdev})
                delete(app.figcolor{app.selectdev});
            end
            app.deleting_RGB_stream = 1;
        end
    end
end