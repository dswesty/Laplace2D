# Laplace2D
This toy code is a modern Fortran implementation of a 2D Laplace solver which is very similar 
to the 2D Poisson  solver from "Using MPI" by Gropp, Lusk, Skjellum, MIT Press (2014) 
https://wgropp.cs.illinois.edu/usingmpiweb/  .
The code in this repository demonstrates  how to solve the 2D Laplace equation in 
parallel, using the finite difference method and a simple a Jacobi iteration scheme, 
together with the MPI message passing library to achieve a parallelism.  For details see 
"Using MPI" chapter 4.  The solution of the Laplace equation in this case yields the temperature 
field for a square plate heated on two boundaries.  

A makefile is included that will build the code assuming that an MPI implementation which 
provides an mpif90 script is present.    Both the MPICH (https://www.mpich.org) and the
Open MPI (https://www.open-mpi.org/) implentations of the MPI standard should provide 
these scripts.  The code can be built on the Linux command command line with the command: 

        make

If the Makefile runs successfully it will produce an executable file named laplace.   This file 
can then be executed in parallel with two processes using the command:

         mpirun -n 2 laplace

This should produce output similar to

 Number of iterations =         115
 Maximum change on last iteration =   9.3860688465952080E-007
 PE #  ROW        Temperature field
   0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
   0    1  0.00000E+00  2.38095E+00  4.76190E+00  7.14285E+00  9.52381E+00  1.19048E+01  1.42857E+01  1.66667E+01
   0    2  0.00000E+00  4.76190E+00  9.52381E+00  1.42857E+01  1.90476E+01  2.38095E+01  2.85714E+01  3.33333E+01
   0    3  0.00000E+00  7.14285E+00  1.42857E+01  2.14286E+01  2.85714E+01  3.57143E+01  4.28571E+01  5.00000E+01
   1    4  0.00000E+00  9.52381E+00  1.90476E+01  2.85714E+01  3.80952E+01  4.76190E+01  5.71429E+01  6.66667E+01
   1    5  0.00000E+00  1.19048E+01  2.38095E+01  3.57143E+01  4.76190E+01  5.95238E+01  7.14286E+01  8.33333E+01
   1    6  0.00000E+00  1.42857E+01  2.85714E+01  4.28571E+01  5.71429E+01  7.14286E+01  8.57143E+01  1.00000E+02
   1    7  0.00000E+00  1.66667E+01  3.33333E+01  5.00000E+01  6.66667E+01  8.33333E+01  1.00000E+02  1.16667E+02

Indicating the code took 115 iterations to converge and had a maximum temperature change over 
all zones of approximately 9.39e-7 on the last iteration.   The rest of the table displays 
the temperature in each zone (including the boundary conditions on the east and south sides 
of the mesh).   Note that no effort has been made to be numerically rigorous in achieving this 
solution as the purpose of the code is to demonstrate how message passing works to achieve 
parallelism.   The Jacobi iteration scheme used in this code does not converge rapidly.

You could also try running this replacing the 2 with 1 or 3 to try a single process or three 
processes. The problem is set to run with 2D mesh 6x6 in size and the domain decomposition is 
a 1D slab decomposition (see "Using MPI" for details).    Given the small size of the problem 
it would make little sense to run this code with more processes and no attempt has been made 
to make this  code bulletproof to deal with the event that the user tries to run with a larger 
number of processes.     

The mesh size can be changed via the named constants NX and NY found in the problem_dims 
module located in the PROBLEM_DIMS_MOD.f90 file.    If the mesh size is made much larger 
than 6x6 you should probably comment out the output lines in the laplace.f90 program and add 
your own output to a file for graphics purposes.
