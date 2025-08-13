!  Module:   problem_dims
!  Purpose:  Specify the dimensions of the Lpalace problem
!  Author:   F. Douglas Swesty
!  Date:     12/11/24
module problem_dims
  use real_kind, only: DT
  implicit none
  integer, parameter :: NX=6                     ! Size of active grid in X dimension
  integer, parameter :: NY=6                     ! Size of active grid in Y dimension
  real(kind=DT) :: XMAX=1.0d0*NX                 ! Maximum X coordinate
  real(kind=DT) :: YMAX=1.0d0*NY                 ! Maximum Y coordinate

  real(kind=DT), allocatable :: xcoords(:)       ! X coordinates
  real(kind=DT), allocatable :: ycoords(:)       ! X coordinates
end module problem_dims
