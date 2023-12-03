program plot
    use,intrinsic :: iso_fortran_env, only: wp => real64
    use iso_c_binding
    use pyplot_module

    implicit none
    
    integer :: argc, e
    character(10) :: arg
    character(10) :: arg_num

    type(c_ptr) :: ht_s, ht_p, map

    integer :: col, i
    integer :: element_count
    real(wp), allocatable :: arg_array(:)
    real(wp), allocatable :: col_s_array(:)
    real(wp), allocatable :: col_p_array(:)
    
    real(wp) :: hts_time, htp_time, map_time
    integer :: start_time, end_time, time_rate
    real(wp) :: nums(3)

    character(10) :: int_str

    type(pyplot) :: plt

    nums = [1.0, 2.0, 3.0]

    argc = command_argument_count();

    if(argc /= 2) then
        print *, "Usage: plot < -t | -c > <element_count>"
        return
    end if

    call get_command_argument(1, arg)
    if(arg /= "-c" .and. arg /= "-t") then
        print *, "Argument (-c or -t) expected. xd"
        return
    end if

    call get_command_argument(2, arg_num)
    read(arg_num, *, iostat=e) element_count
    if(e /= 0) then
        print *, "Second argument must be number."
        return
    end if

    allocate(arg_array(element_count))
    allocate(col_s_array(element_count))
    allocate(col_p_array(element_count))

    print *, "Creating Hash Table"
    call ht_s_create(ht_s)
    call ht_p_create(ht_p)
    call map_create(map)

    if(arg == "-c") then 
        print *, "Calculating collisions"
        do i = 1, element_count
            arg_array(i:i) = i
            write(int_str, '(i10)') i * 13

            call ht_s_add(ht_s, "xyz"//int_str//c_null_char, char(i)//c_null_char)
            call ht_s_count_collisions(ht_s, col)
            col_s_array(i:i) = col

            call ht_p_add(ht_p, "x"//int_str//c_null_char, char(i)//c_null_char)
            call ht_p_count_collisions(ht_p, col)
            col_p_array(i:i) = col
        end do


        print *, "Plotting"
        call plt%initialize(grid=.true., title="Коллизии",&
            xlabel="Количество элементов",  ylabel="Количество коллизий",&
            legend=.true.)

        call plt%add_plot(arg_array, col_s_array, label="std::hash",&
            linestyle="--", markersize=5, linewidth=2)

        call plt%add_plot(arg_array, col_p_array, label="polynomialHash",&
            linestyle="-.", markersize=5, linewidth=2)

        call plt%savefig("collisions.png")

    else if(arg == "-t") then
        print *, "Measuring time"

        print *, "Measuring ht_s"
        call system_clock(start_time, time_rate)
        do i = 1, element_count
            write(int_str, '(i10)') i * 13
            call ht_s_add(ht_s, "xyz"//int_str//c_null_char, char(i)//c_null_char)
        end do
        call system_clock(end_time, time_rate)
        hts_time = real(end_time - start_time) / real(time_rate)
        print *, hts_time

        print *, "Measuring ht_p"
        call system_clock(start_time, time_rate)
        do i = 1, element_count
            write(int_str, '(i10)') i * 13
            call ht_p_add(ht_p, "xyz"//int_str//c_null_char, char(i)//c_null_char)
        end do
        call system_clock(end_time, time_rate)
        htp_time = real(end_time - start_time) / real(time_rate)
        print *, htp_time

        print *, "Measuring map"
        call system_clock(start_time, time_rate)
        do i = 1, element_count
            write(int_str, '(i10)') i * 13
            call map_add(map, "xyz"//int_str//c_null_char, char(i)//c_null_char)
        end do
        call system_clock(end_time, time_rate)
        map_time = real(end_time - start_time) / real(time_rate)
        print *, map_time

        print *, "Plotting"
        
        call plt%initialize(grid=.true., title="Время добавления "//arg_num//" элементов",&
              ylabel="Время, с", legend=.true.)

        call plt%add_bar(nums(1:1), [hts_time], label="HashTable, std::hash")
        call plt%add_bar(nums(2:2), [htp_time], label="HashTable, PolynomialHash")
        call plt%add_bar(nums(3:3), [map_time], label="std::unordered_map")

        call plt%savefig("time.png")

    end if

    print *, "Destroying Hash Table"
    call ht_s_destroy(ht_s)
    call ht_p_destroy(ht_p)
    call map_destroy(map)
end program
