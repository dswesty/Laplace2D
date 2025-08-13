# Laplace2D
Fortran implementation of 2D Laplace problem from "Using MPI" by Gropp, Lusk, Skjellum, MIT Press (2014)
This is a impelentation of the 2D Laplace demonstration problem from "Using MPI" whcih demonstrates 
how do do a simple Jacobi iteration scheme along with the MPI message passing library to achieve a parallel 
solution of the 2D Laplace problem for a plate heated on two boundaries.  

A makefile is included that will build the code assuming that an MPI implementation which provides an mpif90 script is present.    Both the MPICH and Open MPI implentations of MPI should provide these scripts.  The code can be built on the Linux command cline with the command: 

        make

If the Makefile runs successfully it will produce an executable file named laplace.   This file 
an be executed in parallel with two processes using the command:

         mpirun -n 2 laplace

The executable is set to output a table showing the converged solution of the temperature field.   The problem is set to run with 2D mesh 6x6 in size.  The mesh size can be changed via the named constants NX and NY found in the problem_dims module locatedin the PROBLEM_DIMS_MOD.f90 file

If the mesh size is made much larger than 6x6 you should probably comment out the output lines in the laplace.f90 program and add 
your own output to a file for graphics purposes.
