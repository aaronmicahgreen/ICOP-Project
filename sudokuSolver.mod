#This code is modified from https://neos-guide.org/content/sudoku

param m >= 1, integer, default 3;
param n := m*m;
set N := 1..n;

option randseed 2345;

#prespecified data values
param P{N,N} default 0, integer, >= 0, <= n;

#attempt to create an initial guess
for{x in 1..n}{
	for{y in 1..n}{
		let P[x,y] := Irand224() mod 9;
	};
};
#this is the general command to build the initial guess Above is a different version
#let P {x in 1..9, y in 1..9} := Irand224() mod 9;

# z[i,j,k] = 1 if digit k is in row i and column j
var z{N,N,N} binary;

#set the initial guess as the variable to be solved
for{i in N}{
	for{j in N}{
		for{k in N}{
			if P[i,j] <> 0 then let z[i,j,P[i,j]] := 1;
			}
		}
	}
	
#display z;
#let z[N,N,N] := Irand224() mod 9; 

# dummy objective
minimize obj: 0;

# only one of each digit in each column
subject to col_sum{j in N, k in N}: 
     sum{i in N} z[i,j,k] = 1;

# only one of each digit in each row
subject to row_sum{i in N, k in N}: 
     sum{j in N} z[i,j,k] = 1;

# only one of each digit in each box
#subject to sqr_sum{r in 0..m-1, c in 0..m-1, k in N}:
   #sum{p in 1..m, q in 1..m} z[m*r+p,m*c+q,k] = 1;
   
#Alternate "one digit each box" constraint
subject to sub_matr{k in 1..n, p in 1..m, q in 1..m}:
	sum{j in m*q-m+1..m*q, i in m*p-m+1..m*p} z[i,j,k] = 1;

# only one digit in each cell
subject to unique{i in N, j in N}: sum{k in N} z[i,j,k] = 1;

# fix position of prespecified values
#subject to fixed{i in N, j in N: P[i,j] <> 0}:
      #z[i,j,P[i,j]] = 1;

#data;
#param m:= 3;

#param P{x in N, y in N} = Irand224() mod 9; 
#param P:  1  2  3 4  5  6 7  8  9 :=
#1         1  .  .  .  .  6  3  .  8
#2         .  .  2  3  .  .  .  9  .
#3         .  .  .  .  .  .  7  1  6

#4         7  .  8  9  4  .  .  .  2
#5         .  .  4  .  .  .  9  .  .
#6         9  .  .  .  2  5  1  .  4

#7         6  2  9  .  .  .  .  .  .
#8         .  4  .  .  .  7  6  .  .
#9         5  .  7  6  .  .  .  .  3 ;

solve;

#display the results
for {i in N}{
    for {j in N}{
      for {k in N}{
         if (z[i,j,k] == 1) then printf "%3i", k;
      };
      if ((j mod m) == 0) then printf " | ";
   };
   printf "\n";
   if ((i mod m) == 0) then {
      for {j in 1..m}{
         for {k in 1..m-1}{ printf "---" };
         if (j < m) then
            printf "----+-";
         else
            printf "----+\n";
      };
   };
};

