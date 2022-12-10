program day10
    integer :: v
    character(len=200) :: line
    integer :: ios
    integer :: cur = 1, cycles_needed = 1
    integer :: cycles = 1, current_stop = 1
    integer, dimension(6) :: stops = (/ 20, 60, 100, 140, 180, 220/)
    integer :: part_1 = 0
    character(len=40), dimension(6) :: part_2
    
    open(unit=9, file='../inputs/day10.txt')    
    do   
        read(9, '(A4, X, i10.1)', iostat=ios) line, v
        if ( ios /= 0 ) exit
        
        cycles_needed = 1
        if ( line /= 'noop' ) cycles_needed = 2   

        do i=1,cycles_needed     
            if ( MOD(cycles-1, 40) >= cur - 1 .and. MOD(cycles-1, 40) <= cur + 1 ) then
                write(part_2(1 + cycles/40)(MOD(cycles-1,40)+1:), fmt='(A1)') '#'
            else 
                write(part_2(1 + cycles/40)(MOD(cycles-1,40)+1:), fmt='(A1)') '.'
            end if

            if ( stops(current_stop) == cycles ) then
                part_1 = part_1 + stops(current_stop) * cur
                current_stop = current_stop + 1
            end if

            cycles = cycles + 1
        end do   
        if ( cycles_needed == 2 )  cur = cur + v 
    end do
    close(9)

    write(*, '(A, I6)') 'Part_1:', part_1
    write(*, fmt='(A)') 'Part_2:', part_2    
end program day10