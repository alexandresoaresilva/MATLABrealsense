function delete_all_cams_fig(app, event)
    if isvalid(app)
        if isvalid(app.figall) && ~strcmp(app.timerall.Running,'off')
            stop(app.timerall);
        end
        if isvalid(app.figall)
            delete(app.figall);
        end
    end
end