function ptc = denoiseAndTrimPC(ptc, cameraIdx)
    switch cameraIdx
        case 0
            maxDist = 1.1;
        case 1            
            maxDist = 1.1;
        case 2
%             if ptc.Count > 1000
%                 thresh = 0.10;
%                 [model,inlierIndices,outlierIndices, meanError] = pcfitplane(ptc, thresh);
%                 if meanError < (thresh)
%                     ptc = ptc.select(outlierIndices);
%                 end
%             end
    maxDist = 1.2;
    end
    toRemove = find(ptc.Location(:,3) < maxDist);
    if numel(toRemove) > 0
        ptc = ptc.select(toRemove);
    end
    toRemove = find(ptc.Location(:,3) > 0.2);
    if numel(toRemove) > 0
        ptc = ptc.select(toRemove);
    end
    
    if ptc.Count > 0
        ptc = pcdenoise(ptc, .... 
                'NumNeighbors', 16 , ...
                'Threshold', 0.5);
    end
end