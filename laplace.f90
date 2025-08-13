!2345678901234567890123456789012345678901234567890123456789012345678901234567890
!  Program:  laplace
!  Purpose:  Solve the Laplace equation
!  Author:   F. Douglas Swesty
!  Date:     8/13/25
  
!------------------------------------------------------------------------------

program laplace

  use real_kind, only: DT
  use problem_dims, only: NX, NY, xcoords, ycoords
  use boundary_cond, only: boundary_cond_x, boundary_cond_y
  use domain_decomp, only: is,ie,js,je, NGZ, left_PE, right_PE

  implicit none
  include 'mpif.h'

  integer, parameter :: out_lun=0                    ! LUN for output
  
  integer :: num_PEs                                 ! Number of MPI PEs
  integer :: my_rank                                 ! Rank in MPI communicator
  integer :: errorcode                               ! Error code for MPI calls
  integer :: num_zones_per_PE                        ! Number of zones per PE

  
  integer, parameter :: msg_tag_left =1001           ! Messg. tag for send left
  integer, parameter :: msg_tag_right=1002           ! Messg. tag for send right
  integer, parameter :: msg_tag_seq=1003             ! Message tag for
                                                     !        sequentail section

  real(kind=DT) :: sendbuff_left(0:NY+1)             ! Left send buffer
  real(kind=DT) :: sendbuff_right(0:NY+1)            ! Right send buffer
  real(kind=DT) :: recvbuff_left(0:NY+1)             ! Left receive buffer
  real(kind=DT) :: recvbuff_right(0:NY+1)            ! Right receive buffer
  

  integer :: status(MPI_STATUS_SIZE)                 ! MPI error status

  real(kind=DT) :: maxchange=1.0d99                  ! Max change per iteration
  real(kind=DT) :: maxchange_local                   ! Max change per iteration
  integer :: iter_count=0                            ! Iteration count
  
  real(kind=DT), allocatable :: t_old(:,:)           ! Old value of Temperature
  real(kind=DT), allocatable :: t_new(:,:)           ! Old value of Temperature

  integer :: i                                       ! Loop index in X-direction
  integer :: j                                       ! Loop index in y-direction

  integer ::iub                                      ! Upper output bound for i

  real(kind=DT) :: seq_snd_buf(1)                    ! Buffer for seq. send
  real(kind=DT) :: seq_rcv_buf(1)                    ! Buffer for seq. receive

!------------------------------------------------------------------------------
  
  call MPI_INIT(errorcode)                              ! Initialize MPI

  call MPI_COMM_RANK(MPI_COMM_WORLD,my_rank,errorcode)  ! Get rank

  Call MPI_COMM_SIZE(MPI_COMM_WORLD,num_PEs,errorcode)  ! Get number of PEs

  num_zones_per_PE = NX/num_PEs                         ! number of X zones
                                                        !      per PE


  if(my_rank > 0) then                                  ! Set PEs to left &
    left_PE = my_rank-1                                 ! right
  else
    left_PE = -99
  endif

  if(my_rank < num_PEs-1) then
    right_PE = my_rank+1
  else
    right_PE = -100
  endif

  
  is = my_rank*num_zones_per_PE+1                       ! Start i-index

  if(my_rank /= num_PEs-1) then                         ! End i-index
    ie = (my_rank+1)*num_zones_per_PE
  else
    ie = NX
  endif
  js = 1
  je = NY



  allocate(xcoords(is-NGZ:ie+NGZ))                      ! Allocate X array
  allocate(ycoords(js-NGZ:je+NGZ))

  allocate(t_old(is-NGZ:ie+NGZ,js-NGZ:je+NGZ))          ! Allocate old &
                                                        ! new T arrays
  allocate(t_new(is-NGZ:ie+NGZ,js-NGZ:je+NGZ))


  do i=is-NGZ,ie+NGZ                                    ! Initialize X coords.
     xcoords(i) = i
  enddo

  do j=js-NGZ,je+NGZ                                    ! Initialize Y coords.
     ycoords(j) = j
  enddo


  t_old = 0.0d0                                         ! Initialize temperat.

  
  do i=is-NGZ,ie+NGZ                                    ! Set boundary conds.
     t_old(i,je+NGZ) = boundary_cond_x(xcoords(i))
     t_old(i,js-NGZ) = 0.0d0
  enddo
  if(my_rank == 0) then
     t_old(is-NGZ,js-NGZ:je+NGZ) = 0.0d0
  endif
  if(my_rank == num_PEs-1) then
     do j=js-NGZ,je+NGZ
        t_old(ie+NGZ,j) = boundary_cond_y(ycoords(j))
     enddo
  endif
     
  t_new = t_old                                         ! Init bound conds. on
                                                        ! new temperature




  do while(maxchange > 1.0d-2)

                                                        ! Xchange bound. conds.

    if(my_rank > 0) then                                ! Send bound. data left
       sendbuff_left  = t_old(is,:)
       call MPI_Send(sendbuff_left, NY+2*NGZ, MPI_DOUBLE_PRECISION, &
                     left_PE, msg_tag_left, MPI_COMM_WORLD,errorcode)

    endif

    if(my_rank < num_PEs-1) then                        ! Send bound. data rght
       sendbuff_right = t_old(ie,:)
       call MPI_Send(sendbuff_right, NY+2*NGZ, MPI_DOUBLE_PRECISION, &
                     right_PE, msg_tag_right, MPI_COMM_WORLD, errorcode)
    endif

    
    if(my_rank > 0) then                                ! Rcv. bound. data left 
       call MPI_Recv(recvbuff_left, NY+2*NGZ, MPI_DOUBLE_PRECISION, &
                     left_PE,msg_tag_right, MPI_COMM_WORLD, status, errorcode )
            t_old(is-NGZ,:) = recvbuff_left             ! Unpack recv. buffer
    endif


    if(my_rank < num_PEs-1) then                        ! Rcv. bound. data rght
       call MPI_Recv(recvbuff_right, NY+2*NGZ, MPI_DOUBLE_PRECISION, &
                     right_PE, msg_tag_left,  MPI_COMM_WORLD, status, errorcode)
            t_old(ie+NGZ,:) = recvbuff_right            !  Unpack rcv. buffer
    endif



    
     do j=js,je                                         ! Jacobi iteration
        do i=is,ie
           t_new(i,j) = 0.25d0*( t_old(i+1,j) + t_old(i-1,j) + &
                                 t_new(i,j+1) + t_new(i,j-1)   )
        enddo
     enddo

                                                        ! Local max chng. in
                                                        ! temperature 
     maxchange_local = maxval(abs(t_old(is:ie,js:je) - t_new(is:ie,js:je))) 

                                                        ! Reduction operation
                                                        ! to get global max
                                                        ! error
     call MPI_Allreduce(maxchange_local, maxchange, 1, MPI_DOUBLE, &
                        MPI_MAX,MPI_COMM_WORLD,  errorcode)

     t_old = t_new                                      ! Update solution
     
     iter_count = iter_count+1                          ! Incr. iter. counter
     
  enddo

                                                        ! Do one final
                                                        !     exchange of
                                                        !     boundary values

  if(my_rank > 0) then                                  ! Send boundary data
                                                        ! left
       sendbuff_left  = t_old(is,:)
       call MPI_Send(sendbuff_left, NY+2*NGZ, MPI_DOUBLE_PRECISION, &
                     left_PE, msg_tag_left, MPI_COMM_WORLD, errorcode )
    endif

    if(my_rank < num_PEs-1) then                        ! Send boundary data
                                                        ! right
       sendbuff_right = t_old(ie,:)
       call MPI_Send(sendbuff_right, NY+2*NGZ, MPI_DOUBLE_PRECISION, &
                     right_PE, msg_tag_right, MPI_COMM_WORLD, errorcode)
    endif

    
    if(my_rank > 0) then                                ! Recv. boundary data
                                                        ! from left 
       call MPI_Recv(recvbuff_left, NY+2*NGZ, MPI_DOUBLE_PRECISION, left_PE, &
                     msg_tag_right, MPI_COMM_WORLD, status, errorcode)
            t_old(is-NGZ,:) = recvbuff_left             ! Unpack recv. buffer
    endif


    if(my_rank < num_PEs-1) then                        ! Recv. boundary data
                                                        ! from right
       call MPI_Recv(recvbuff_right, NY+2*NGZ, MPI_DOUBLE_PRECISION, &
                     right_PE, msg_tag_left, MPI_COMM_WORLD, status, errorcode)
            t_old(ie+NGZ,:) = recvbuff_right            ! Unpack receive buffer
    endif


                                                  ! Output solution as a table
    if(my_rank == 0) then
      write(out_lun,*) '-----------------------------------------------------'
      write(out_lun,*) 'iter #, maximum change =', iter_count, maxchange
      if(num_PEs == 1) then
        iub = ie+NGZ
      else
        iub = ie
      endif

      do i=is-NGZ,iub
         write(out_lun,'(i4,1x,i4,8(1x,es12.5))') my_rank, i,  &
                                                  t_old(i,js-NGZ:je+NGZ)
      enddo
      
      seq_snd_buf = my_rank
      
      if(num_PEs > 1) then
         call MPI_Send(seq_snd_buf, 1, MPI_DOUBLE_PRECISION, right_PE, &
                       msg_tag_seq, MPI_COMM_WORLD, errorcode)
      endif
         
    elseif(0 < my_rank .and. my_rank < num_PEs-1) then
      call MPI_Recv(seq_rcv_buf, 1, MPI_DOUBLE_PRECISION, left_PE,  &
                    msg_tag_seq, MPI_COMM_WORLD, status, errorcode)
      do i=is,ie
         write(out_lun,'(i4,1x,i4,8(1x,es12.5))') my_rank, i,  &
                                                  t_old(i,js-NGZ:je+NGZ)
      enddo
      seq_snd_buf = my_rank
      call MPI_Send(seq_snd_buf, 1, MPI_DOUBLE_PRECISION, right_PE,  &
                    msg_tag_seq, MPI_COMM_WORLD,errorcode)
    else
      call MPI_Recv(seq_rcv_buf, 1, MPI_DOUBLE_PRECISION, left_PE, &
                    msg_tag_seq, MPI_COMM_WORLD, status, errorcode)
      do i=is,ie+NGZ
        write(out_lun,'(i4,1x,i4,8(1x,es12.5))') my_rank,i, &
              t_old(i,js-NGZ:je+NGZ)
      enddo
      write(out_lun,*) '------------------------------------------------------'
    endif



  
  call MPI_FINALIZE(errorcode)                           ! Finalize MPI

  stop 0
  
end program laplace
