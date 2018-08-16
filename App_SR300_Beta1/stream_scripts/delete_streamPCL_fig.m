function delete_streamPCL_fig(app, event)
    if isvalid(app)
        if ~strcmp(app.timerpcl.Running,'off')
            stop(app.timerpcl);
        end

        delete(app.figpcl)
    end
end