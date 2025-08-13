# Laplace2D
This code is a modern Fortran implementation of a 2D Laplace solver which is very similar to the 2D Poisson solver from "Using MPI" by Gropp, Lusk, Skjellum, MIT Press (2014) https://wgropp.cs.illinois.edu/usingmpiweb/ 
The code in this repository demonstrates  how to solve the 2D Laplace equation in parallel, using the finite difference method and a simple a Jacobi iteration scheme, using the MPI message passing library to achieve a parallelism.  For details see "Using MPI" chapter 4.  The solution of the Laplace equation in this case yields the temperature field for a plate heated on two boundaries.  

A makefile is included that will build the code assuming that an MPI implementation which provides an mpif90 script is present.    Both the MPICH (https://www.mpich.org) and Open MPI (https://www.open-mpi.org/) implentations of the MPI standard should provide these scripts.  The code can be built on the Linux command command line with the command: 

        make

If the Makefile runs successfully it will produce an executable file named laplace.   This file can then be executed in parallel with two processes using the command:

         mpirun -n 2 laplace

You could also try running this replacing the 2 with 1 or 3 to try a single process or 3 processes. The problem is set to run with 2D mesh 6x6 in size and the domain decomposition is a 1D slab decomposition (see "Using MPI" for details).    Given the small size of the problem it would make little sense to run this code with more processes and no attempt has been made to make this code bulletproof to deal with the event that the user tries to run with a larger number of processes.     

The mesh size can be changed via the named constants NX and NY found in the problem_dims module located in the PROBLEM_DIMS_MOD.f90 file.    If the mesh size is made much larger than 6x6 you should probably comment out the output lines in the laplace.f90 program and add 
your own output to a file for graphics purposes.
