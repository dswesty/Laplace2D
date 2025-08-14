# Laplace2D

## Introduction
This toy code is a modern Fortran ( > Fortran 90  ) implementation of a 2D Laplace equation solver which is very similar 
to the 2D Poisson equation solver from [Using MPI](https://wgropp.cs.illinois.edu/usingmpiweb/) by Gropp, 
Lusk, Skjellum, MIT Press (2014). The code in this repository demonstrates  how to solve the 
2D Laplace equation,

$$\nabla^2 T = 0$$ ,

in parallel, using the finite difference method and a simple Jacobi iteration scheme, 
together with the [MPI](https://en.wikipedia.org/wiki/Message_Passing_Interface) message passing interface library to achieve a parallelism via spatial domain decomposition.   For 
details see  [Using MPI](https://wgropp.cs.illinois.edu/usingmpiweb/) chapter 4.  The solution of the 
Laplace equation in this case yields the temperature field for a square plate heated on two boundaries.  

## Building and Execution
A makefile is included that will build the code assuming that an MPI implementation which 
provides an mpif90 script is present.    Both the [MPICH](https://www.mpich.org) and the
[Open MPI](https://www.open-mpi.org/) implentations of the [MPI](https://www.mpi-forum.org/) standard should 
provide these scripts.  The code can be built on the Linux command command line with the command: 

        make

If the Makefile runs successfully it will produce an executable file named **laplace**.   This file 
can then be executed in parallel with two processes using the command:

         mpirun -n 2 laplace

This should produce output similar to
```
 Number of iterations =         115
 Maximum change on last iteration =   9.3860688465952080E-007
--------------------------------------------------------
  PE#  ROW        Temperature field
 --------------------------------------------------------
   0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
   0    1  0.00000E+00  2.38095E+00  4.76190E+00  7.14285E+00  9.52381E+00  1.19048E+01  1.42857E+01  1.66667E+01
   0    2  0.00000E+00  4.76190E+00  9.52381E+00  1.42857E+01  1.90476E+01  2.38095E+01  2.85714E+01  3.33333E+01
   0    3  0.00000E+00  7.14285E+00  1.42857E+01  2.14286E+01  2.85714E+01  3.57143E+01  4.28571E+01  5.00000E+01
   1    4  0.00000E+00  9.52381E+00  1.90476E+01  2.85714E+01  3.80952E+01  4.76190E+01  5.71429E+01  6.66667E+01
   1    5  0.00000E+00  1.19048E+01  2.38095E+01  3.57143E+01  4.76190E+01  5.95238E+01  7.14286E+01  8.33333E+01
   1    6  0.00000E+00  1.42857E+01  2.85714E+01  4.28571E+01  5.71429E+01  7.14286E+01  8.57143E+01  1.00000E+02
   1    7  0.00000E+00  1.66667E+01  3.33333E+01  5.00000E+01  6.66667E+01  8.33333E+01  1.00000E+02  1.16667E+02
```
indicating the code took 115 iterations to converge and had a maximum temperature change over 
all zones of approximately 9.39e-7 on the last iteration.   The rest of the table displays 
the PE number (in column 1) and the row number (in column 2) followed by the temperature in each 
zone of the row (including the boundary zones on the exterior of the mesh).   Since the table includes 
boundary cells on each edge it is 8x8 in size instead of 6x6.

You could also try running this replacing the 2 in the mpirun command with 1 or 3 to execute 
with a single process or three processes repectively. The problem is set to run with 2D 
mesh 6x6 (8x8 including boundary cells) in size and the domain decomposition is a 1D slab decomposition (see 
[Using MPI](https://wgropp.cs.illinois.edu/usingmpiweb/) for details).    Given the small size 
of the problem it would make little sense to run this code with more processes and no attempt has 
been made  to make this  code bulletproof to deal with the event that the user tries to run with 
a more than 6 processes.     

The Makefile has a clean target which will clean up the build files (the object and module files)
and this can be executed on the Linux command line as

    make clean

## Notes
The mesh size can be changed via the named constants **NX** and **NY** found in the problem_dims 
module located in the **PROBLEM_DIMS_MOD.f90** file.    If the mesh size is made much larger 
than 6x6 you should probably comment out the output lines in the **laplace.f90** program and add 
your own output code to send the data to a file for graphics purposes.

The convergence criterion for the Jacobi iteration simply checks the maximum change from one iteration
to the next over all zones and comapares it to a named contant **JACOBI_TOLERANCE** which is set to 1.0e-6.

Note that no effort has been made to be rigorous in achieving this numerical
solution as the primary purpose of the code is to demonstrate how message passing works to achieve 
parallelism.   The Jacobi iteration scheme used in this code does not converge rapidly and
is not an efficient way to solve the Laplace equation for large problems.   For a more detailed 
description of the finite difference method and Jacobi iteration consult 
[Finite Difference Methods for 
Ordinary and Partial Differential Equations: Steady-State and Time-Dependent Problems](https://faculty.washington.edu/rjl/fdmbook/) 
by Randall J. LeVeque, SIAM (2014).

## Code Conventions

Files containing modules are named in upper case, e.g. **REAL_KIND_MOD.f90**, while all other
source code files are named in lowercase.   All source code is written in modern Fortran
using free form syntax.     Named constants, a.k.a. parameters, are encoded in uppercase 
and all variables are encoded in lowercase.   All MPI subroutine references begin with
uppercase MPI_ follwed by the capitalized remainder of the subroutine name.   All 
floating point variables and floating point constants are encoded as double precision.

## License
  All files in this repository were created in under the GPL-2.0 software license and are open source 
  and free for use under the terms of the GPL-2.0 license.
  

