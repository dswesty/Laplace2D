# Laplace2D
Fortran implementation of 2D Laplace problem from "Using MPI" by Gropp, Lusk, Skjellum, MIT Press (2014)
This is a impelentation of the 2D Laplace demonstration problem from "Using MPI" whcih demonstrates 
how do do a simple Jacobi iteration scheme along with the MPI message passing library to achieve a parallel 
solution of the 2D Laplace problem for a plate heated on two boundaries.  A makefile is included that will
build the code assuming that an MPI implementation that provides an mpif90 script is present.    Both the 
MPICH and Open MPI implentations of MPI should provide this.


