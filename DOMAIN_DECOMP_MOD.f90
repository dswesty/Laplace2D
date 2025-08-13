!  Module:   domain_decomp
!  Purpose:  Hold parameters related to domain decomposition
!  Author:   F. Douglas Swesty
!  Date:     12/11/24
module domain_decomp
  implicit none
  integer, parameter :: NGZ=1                        ! Number of ghost zones
  integer :: is                                      ! Start of i index
  integer :: ie                                      ! End of i index
  integer :: js                                      ! Start of j index
  integer :: je                                      ! End of j index  
  integer :: left_PE                                 ! Number of PE to left
  integer :: right_PE                                ! Number of PE to right
end module domain_decomp

