!  Module:   boundry_cond_mod
!  Purpose:  Specify the boundary conditions of the Laplace problem
!            with temperature varying linearly from 0 to 100 along
!            the east and south boundaries
!  Author:   F. Douglas Swesty
!  Date:     12/11/24
module boundary_cond
  implicit none
contains

  function boundary_cond_x(x) result(bcond)  ! Boundary conds. in X (south)
    use real_kind, only: DT
    use problem_dims, only: XMAX
    implicit none
    real(kind=DT) :: bcond
    real(kind=DT), intent(in) :: x
    bcond = 100.0d0*(x/XMAX)
    return
  end function boundary_cond_x

  function boundary_cond_y(y) result(bcond)  ! Boundary conds. in X (east)
    use real_kind, only: DT
    use problem_dims, only: YMAX
    implicit none
    real(kind=DT) :: bcond
    real(kind=DT), intent(in) :: y
    bcond = 100.0d0*(y/YMAX)
    return
  end function boundary_cond_y
  
end module boundary_cond
