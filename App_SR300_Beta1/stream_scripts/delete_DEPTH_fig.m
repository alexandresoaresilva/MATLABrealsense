function delete_DEPTH_fig(app, event)
	if isvalid(app)
		if ~strcmp(app.timerdepth.Running,'off')
		   stop(app.timerdepth);
		end
		delete(app.figdepth);
	end
end