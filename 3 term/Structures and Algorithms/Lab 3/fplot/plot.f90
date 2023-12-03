program plot
    use,intrinsic :: iso_fortran_env, only: wp => real64
    use iso_c_binding
    use pyplot_module

    implicit none

    type(c_ptr) :: ht

    integer :: col
    integer :: i
    real(wp) :: arg_array(1000)
    real(wp) :: col_array(1000)

    character(10) :: int_str

    type(pyplot) :: plt


    print *, "Creating Hash Table"
    call ht_s_create(ht)

    print *, "Calculating collisions"
    do i = 1, 1000
        write(int_str, '(i10)') i
        call ht_s_add(ht, "x"//int_str//c_null_char, char(i)//c_null_char)
        call ht_s_count_collisions(ht, col)
        arg_array(i:i) = i
        col_array(i:i) = col
    end do

    print *, "Destroying Hash Table"
    call ht_s_destroy(ht)

    print *, "Plotting"
    call plt%initialize(grid=.true., title="Коллизии",&
        xlabel="Количество элементов",  ylabel="Количество коллизий",&
        legend=.true.)
    call plt%add_plot(arg_array, col_array, label="std::hash",&
        linestyle="-", markersize=5, linewidth=2)
    call plt%showfig()
end program
