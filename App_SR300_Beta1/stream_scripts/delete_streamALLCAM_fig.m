function delete_streamALLCAM_fig(app, event)
    if isvalid(app)
        if isvalid(app.figall) && ~strcmp(app.timerall.Running,'off')
            stop(app.timerall);
        end
        if isvalid(app.figall)
            delete(app.figall);
        end
    end
end