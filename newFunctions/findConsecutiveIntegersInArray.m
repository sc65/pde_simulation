function consecutiveIntegers = findConsecutiveIntegersInArray(array1, nRepeats)
%% returns consecutive numbers in an vector
% e.g: if array1 = [4 6:20 24], it returns [6:20]
%%
if ~exist('nRepeats', 'var')
    nRepeats = 5;% no. of consecutive repeats.
end

x1 = 1; % number to be check for
V = diff(array1); % vector


b = (V == x1); % create boolean array: ones and zeros
d = diff( [0 b 0] );  % turn the start and end of a run into +1 and -1
startRun = find( d==1 );
endRun = find( d==-1 );
runlength = endRun - startRun;
answer = find(runlength > nRepeats);
%runs = runlength(answer); % number of consecutive integers.


consecutiveIntegers = array1(startRun(answer):endRun(answer));
end