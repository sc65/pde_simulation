
function [patterns2_same, pattern1, relativeError] = comparePatterns(pattern1, pattern2)
%% computes mismatch in two objects. 

if size(pattern1,1) > size(pattern2,1)
    pattern3 = pattern1;
    pattern1 = pattern2;
    pattern2 = pattern3;
end    
patterns2_same = imresize(pattern2, size(pattern1));
patterns2_same = round(patterns2_same);
error = sum(sum(patterns2_same ~= pattern1));
relativeError = error./sum(sum(ones(size(pattern1))));
end