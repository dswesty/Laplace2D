!  Module: real_kind
!  Purpose:  set the kind parameter for the real type
!  Author:   F. Douglas Swesty
!  Date:     12/11/24
module real_kind
  implicit none
  integer, parameter :: DT=kind(1.0d0)     ! Kind value for double precision real
end module real_kind
