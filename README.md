# Laplace2D
This code is a modern Fortran implementation of a 2D Laplace solver which is very similar to the 2D Poisson solver from "Using MPI" by Gropp, Lusk, Skjellum, MIT Press (2014) https://wgropp.cs.illinois.edu/usingmpiweb/  .
The code in this repository demonstrates  how to solve the 2D Laplace equation in parallel, using the finite difference method and a simple a Jacobi iteration scheme, together the MPI message passing library to achieve a parallelism.  For details see "Using MPI" chapter 4.  The solution of the Laplace equation in this case yields the temperature field for a plate heated on two boundaries.  

A makefile is included that will build the code assuming that an MPI implementation which provides an mpif90 script is present.    Both the MPICH (https://www.mpich.org) and Open MPI (https://www.open-mpi.org/) implentations of the MPI standard should provide these scripts.  The code can be built on the Linux command command line with the command: 

        make

If the Makefile runs successfully it will produce an executable file named laplace.   This file can then be executed in parallel with two processes using the command:

         mpirun -np 2

This should produce output similar to


 iter #, maximum change =          48   9.8905092831600427E-003 \\
   0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
   0    1  0.00000E+00  2.36578E+00  4.73639E+00  7.11317E+00  9.49610E+00  1.18840E+01  1.42750E+01  1.66667E+01
   0    2  0.00000E+00  4.73457E+00  9.47784E+00  1.42322E+01  1.89977E+01  2.37722E+01  2.85521E+01  3.33333E+01
   0    3  0.00000E+00  7.10877E+00  1.42284E+01  2.13619E+01  2.85092E+01  3.56677E+01  4.28330E+01  5.00000E+01
   1    4  0.00000E+00  9.48972E+00  1.89903E+01  2.85047E+01  3.80330E+01  4.75725E+01  5.71187E+01  6.66667E+01
   1    5  0.00000E+00  1.18774E+01  2.37636E+01  3.56608E+01  4.75691E+01  5.94864E+01  7.14092E+01  8.33333E+01
   1    6  0.00000E+00  1.42705E+01  2.85459E+01  4.28275E+01  5.71151E+01  7.14078E+01  8.57035E+01  1.00000E+02
   1    7  0.00000E+00  1.66667E+01  3.33333E+01  5.00000E+01  6.66667E+01  8.33333E+01  1.00000E+02  1.16667E+02


Indicating the code took 48 iteration to converge and had a residual of approximately 9.89e-3.   The rest of the table displays the temperature in each zone (including the boundaary conditions on the east and south sides of the mesh).
You could also try running this replacing the 2 with 1 or 3 to try a single process or 3 processes. The problem is set to run with 2D mesh 6x6 in size and the domain decomposition is a 1D slab decomposition (see "Using MPI" for details).    Given the small size of the problem it would make little sense to run this code with more processes and no attempt has been made to make this code bulletproof to deal with the event that the user tries to run with a larger number of processes.     

The mesh size can be changed via the named constants NX and NY found in the problem_dims module located in the PROBLEM_DIMS_MOD.f90 file.    If the mesh size is made much larger than 6x6 you should probably comment out the output lines in the laplace.f90 program and add 
your own output to a file for graphics purposes.
