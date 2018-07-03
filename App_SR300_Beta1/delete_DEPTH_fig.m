function delete_DEPTH_fig(app, event)
    if ~strcmp(app.timerdepth.Running,'off')
       stop(app.timerdepth);
    end
    delete(app.figdepth);
end