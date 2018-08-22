function delete_streamIR_fig(app, event)
    if ~strcmp(app.timerIR.Running,'off')
        stop(app.timerIR);
    end
    delete(app.figIR);
end