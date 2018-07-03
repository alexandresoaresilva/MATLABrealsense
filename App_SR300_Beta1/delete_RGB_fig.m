function delete_RGB_fig(app, event)
    if ~strcmp(app.timercolor{app.selectdev}.Running,'off')
        stop(app.timercolor{app.selectdev});
    end
    delete(app.figcolor{app.selectdev});
end