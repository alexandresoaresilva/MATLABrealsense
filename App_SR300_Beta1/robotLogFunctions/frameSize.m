function frameSize = frameSize(headerVersion)
    if headerVersion >= 2
        frameSize = 1536184;
    else
        error('Must determine framesize for current header version');
    end
end