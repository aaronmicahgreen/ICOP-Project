param m >= 1, integer, default 3;
param n := m*m;
set N := 1..n;

# prespecified data values
param P{N,N} default 0, integer, >= 0, <= n;

# z[i,j,k] = 1 if digit k is in row i and column j
var z{N,N,N} binary;

# dummy objective
minimize nothing: 0;

# only one of each digit in each column
subject to col_sum{j in N, k in N}: 
     sum{i in N} z[i,j,k] = 1;

# only one of each digit in each row
subject to row_sum{i in N, k in N}: 
     sum{j in N} z[i,j,k] = 1;

# only one of each digit in each box
subject to sqr_sum{r in 0..m-1, c in 0..m-1, k in N}:
   sum{p in 1..m, q in 1..m} z[m*r+p,m*c+q,k] = 1;

# only one digit in each cell
subject to unique{i in N, j in N}: sum{k in N} z[i,j,k] = 1;

# fix position of prespecified values
subject to fixed{i in N, j in N: P[i,j] <> 0}:
      z[i,j,P[i,j]] = 1;