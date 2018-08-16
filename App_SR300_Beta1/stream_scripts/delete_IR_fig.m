function delete_IR_fig(app, event)
    if ~strcmp(app.timerIR.Running,'off')
        stop(app.timerIR);
    end
    delete(app.figIR);
end