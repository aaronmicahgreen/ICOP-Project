function clues = createPuzzle(completedPuzzle, numClues, sameSolution)
%createPuzzle: Given a completed, feasible sudoku puzzle, create a new
%              with the specified number of clues (numClues), or if 
%              sameSolution == 1, create a puzzle with as close to
%              (numClues) as possible while guaranteeing that the resulting
%              puzzle will still have the same solution.
%%*************************************************************************

% Convert the inputed puzzle into a 81x3 matrix where each row specifies
% the row, column, and entry for a clue.
completedPuzzle = convertPuzzleToClues(completedPuzzle);

if sameSolution == 1 
    clues = completedPuzzle;
    newClues = clues;
    solution = sudokuSolver(clues, 1);
    clueCount = 81;
    while (clueCount > numClues) & isequal(solution, completedPuzzle)
        clues = newClues;
        clueCount = clueCount - 1;
        rows = randsample(1:length(clues), length(clues)-1);
        newClues = clues(rows, :);
        solution = sudokuSolver(clues, 1);
    end
else
    rows = randsample(1:length(completedPuzzle), min(numClues, 81));
    clues = completedPuzzle(rows,:);
end


end

