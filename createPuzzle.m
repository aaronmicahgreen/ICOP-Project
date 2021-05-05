function clues = createPuzzle(completedPuzzle, numClues)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

if isequal(size(completedPuzzle),[9,9]) % 9-by-9 clues
    % Convert to 81-by-3
    [SM,SN] = meshgrid(1:9); % make i,j entries
    completedPuzzle = [SN(:),SM(:),completedPuzzle(:)]; % i,j,k rows
    % Now delete zero rows
    [rrem,~] = find(completedPuzzle(:,3) == 0);
    completedPuzzle(rrem,:) = [];
end
rows = randsample(1:length(completedPuzzle), min(numClues, 81))
clues = completedPuzzle(rows,:)
end

