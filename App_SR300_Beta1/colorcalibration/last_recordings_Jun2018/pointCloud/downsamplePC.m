function [out] = downsamplePC(in)
%     out = in;
    out = pcdownsample(in, 'random', 0.5);
end