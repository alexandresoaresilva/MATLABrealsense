classdef EncoderLog
    
    properties
        logs
        timeMin
        timeMax
        dMeters
        splines
    end
    
    methods
        function obj = EncoderLog(folderPath)
            obj.logs = cell(2,1);
            for d = dir(folderPath)'
                [~,name,ext] = fileparts(d.name);
                if contains(name, 'Encoder') && strcmp(ext,'.txt')
                    f = fopen([folderPath, filesep, d.name]);
                    temp = fscanf(f, '%ld, %f', [2,inf]);        
                    if contains(name, 'LeftRear')
                        obj.logs{1} = temp;
                    elseif contains(name, 'RightRear')
                        obj.logs{2} = temp;
                    end
                end
            end
            
            for i = 1:2
                startPosition = obj.logs{i}(2,1);
                obj.logs{i}(2,:) = obj.logs{i}(2,:) - startPosition;
                obj.logs{i}(2,:) = obj.logs{i}(2,:)*-12000/10000*12.1*pi*0.0254;
%                 obj.logs{i}(2,:) = obj.logs{i}(2,:)*-12000/10000*12.1*pi*0.0254*8;
            end
            
            for i = 1:2
                toRemove = diff(obj.logs{i}(2,:)) < eps;
                obj.logs{i}(:,toRemove) = [];
            end
            
            minTime = zeros(2,1);
            maxTime = zeros(2,1);
            for i = 1:2
                minTime(i) = min(obj.logs{i}(1,:));
                maxTime(i) = max(obj.logs{i}(1,:));
            end
            obj.timeMin = max(minTime);
            obj.timeMax = min(maxTime);
            
            splines(1) = csaps(obj.logs{1}(1,:), obj.logs{1}(2,:), 5);
            splines(2) = csaps(obj.logs{2}(1,:), obj.logs{2}(2,:), 5);
            obj.splines = splines;
        end
               
        function dMeters = interpDistance( obj, t0, t1 )
                        
            p10 = fnval(obj.splines(1), t0);
            p11 = fnval(obj.splines(1), t1);
            d0 = p11-p10;

            p20 = fnval(obj.splines(2), t0);
            p21 = fnval(obj.splines(2), t1);
            d1 = p21-p20;
            
            dMeters = mean([d0, d1]);
%             dMeters*1000
        end
        
        function dMeters = interpDistanceOld( obj, t0, t1 )
            p00 = interp1(obj.logs{1}(1,:), obj.logs{1}(2,:), t0, 'spline');
            p01 = interp1(obj.logs{1}(1,:), obj.logs{1}(2,:), t1, 'spline');
            d0 = p01-p00;

            p10 = interp1(obj.logs{2}(1,:), obj.logs{2}(2,:), t0, 'spline');
            p11 = interp1(obj.logs{2}(1,:), obj.logs{2}(2,:), t1, 'spline');
            d1 = p11-p10;
            
            dMeters = mean([d0, d1]);
        end
        
        function [tRange] = interpTime( obj, position )
            position = sort(position);
            tMin = zeros(2,1);
            tMax = zeros(2,1);
            for i = 1:2
                [~,temp] = min(abs(obj.logs{i}(2,:)-position(1)));
                temp = find(obj.logs{i}(2,:) == obj.logs{i}(2,temp),1, 'first');
                tMin(i) = obj.logs{i}(1,temp);
                [~,temp] = min(abs(obj.logs{i}(2,:)-position(2)));
                temp = find(obj.logs{i}(2,:) == obj.logs{i}(2,temp),1, 'last');
                tMax(i) = obj.logs{i}(1,temp);
            end
            tRange = [min(tMin), max(tMax)];
            
            if position(1) == -inf
                tRange(1) = obj.timeMin;
            end
            if position(2) == inf
                tRange(2) = obj.timeMax;
            end                        
        end
    end
end










