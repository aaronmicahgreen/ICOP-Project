function clues = convertPuzzleToClues(puzzle)
%convertPuzzleToClues: take a 9x9 matrix of sudoku clues and convert it
%                      into an 81x3 format where each row is of the format
%                      (row number, column number, entry). 0's in the
%                      puzzle will not be converted to clues.
%%*************************************************************************
    if isequal(size(puzzle),[9,9]) % 9-by-9 clues
        % Convert to 81-by-3
        [SM,SN] = meshgrid(1:9); % make i,j entries
        puzzle = [SN(:),SM(:),puzzle(:)]; % i,j,k rows
        % Now delete zero rows
        [rrem,~] = find(puzzle(:,3) == 0);
        puzzle(rrem,:) = [];
    end
    clues = puzzle;
end

