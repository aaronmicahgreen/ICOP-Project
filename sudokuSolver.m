function solution = sudokuSolver(puzzle, clueForm)
% sudokuSolver: take a sudoku puzzle, either in 9x9 form or in clue form,
% convert it into an appropriate set of constraints for Matlab's intlinprog
% solver, and find a solution if possible.
%**************************************************************************
 
    puzzle = convertPuzzleToClues(puzzle);

    n = 9^3;
    m = 4*9^2;
    A = zeros(m,n);
    b = ones(m,1);
    f = zeros(n, 1)';
    lowerBound = zeros(9,9,9);
    upperBound = lowerBound+1;

    %% Set up the constraints
    % In order to get this working with matlab's intlinprog, we need to flatten
    % the constraints into a matrix. It's a less intuitive way to think of the
    % constraints, but matlab doesn't like tensors.

    counter = 1;
    % Create constraint so each row only has one of each number
    for j = 1:9 
        for k = 1:9
            temp = lowerBound; 
            temp(1:end,j,k) = 1; 
            A(counter,:) = temp(:)'; 
            counter = counter + 1;
        end
    end
    % Create constraint so each column only has one of each number
    for i = 1:9 
        for k = 1:9
            temp = lowerBound;
            temp(i,1:end,k) = 1;
            A(counter,:) = temp(:)';
            counter = counter + 1;
        end
    end
    % Create constraint so each 3x3 subgrid only has one of each number
    for U = 0:3:6 
        for V = 0:3:6
            for k = 1:9
                temp = lowerBound;
                temp(U+(1:3),V+(1:3),k) = 1;
                A(counter,:) = temp(:)';
                counter = counter + 1;
            end
        end
    end
    % create constraint so each cell only has one entry
    for i = 1:9 
        for j = 1:9
            temp = lowerBound;
            temp(i,j,1:end) = 1;
            A(counter,:) = temp(:)';
            counter = counter + 1;
        end
    end

    %% We can add the starting clues
    % to the puzzle by changing the lower bound so it includes 1's for the vars
    % that need to be 1's based on the clues

    for i = 1:size(puzzle,1)
        lowerBound(puzzle(i,1),puzzle(i,2),puzzle(i,3)) = 1;
    end


    integerConstraints = 1:n; % we need to specify which vars need to be integers (all of them do)

    % Now we can use intlinprog
    [solution,~,errorFlag] = intlinprog(f,integerConstraints,[],[],A,b,lowerBound,upperBound);

    % Convert the final solution into a 9x9 grid to give us humans a
    % readable solution
    if errorFlag > 0 
        solution = reshape(solution,9,9,9); 
        solution = round(solution); 
        y = ones(size(solution));
        for k = 2:9
            y(:,:,k) = k; 
        end

        solution = solution.*y; 
        solution = sum(solution,3);
    else
        solution = [];
    end  
    
    if clueForm == 1
        % Convert to 81-by-3
        [SM,SN] = meshgrid(1:9); % make i,j entries
        solution = [SN(:),SM(:),solution(:)]; % i,j,k rows
        % Now delete zero rows
        [rrem,~] = find(solution(:,3) == 0);
        solution(rrem,:) = [];
    end
end