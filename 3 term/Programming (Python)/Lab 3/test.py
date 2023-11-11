from unittest import TestCase, main, mock
import io
import lab


class LabTest(TestCase):
    def test_max_num(self):
        a, b, c = 5, 9, 2
        result = lab.max_num(a, b, c)
        self.assertEqual(result, 9)

    def test_sum_nums(self):
        lst = [4, 6, 2, 9]
        result = lab.sum_nums(lst)
        self.assertEqual(result, 21)

    def test_product(self):
        lst = [4, 6, 2, 9]
        result = lab.product(lst)
        self.assertEqual(result, 432)

    def test_str_reverse(self):
        s = "Привет всем!"
        result = lab.str_reverse(s)
        self.assertEqual(result, "!месв тевирП")

    def test_factorial(self):
        result1 = lab.factorial(6)
        self.assertEqual(result1, 720)

        result2 = lab.factorial(0)
        self.assertEqual(result2, 1)

    def test_in_range(self):
        num1, start1, end1 = 40, 35, 69
        self.assertTrue(lab.in_range(num1, start1, end1))

        num2, start2, end2 = 70, 35, 69
        self.assertFalse(lab.in_range(num2, start2, end2))

    def test_count_letters(self):
        s = "Где-то буквы, где-то знаки препинания, где-то цифры 44234."
        result = lab.count_letters(s)
        self.assertEqual(result, 40)

    def test_distinct(self):
        lst = [1, 0, 1, 4, 5, 0, 1, 2, 4, 9]
        result = lab.distinct(lst)
        self.assertEqual(result, [1, 0, 4, 5, 2, 9])

    def test_even_indices(self):
        lst = [1, 0, 1, 4, 5, 0, 1, 2, 4, 9]
        result = lab.even_indices(lst)
        self.assertEqual(result, [1, 1, 5, 1, 4])

    def test_is_palindrome(self):
        s1 = "шалаш"
        self.assertTrue(lab.is_palindrome(s1))

        s2 = "шашал"
        self.assertFalse(lab.is_palindrome(s2))

    def test_wrap_in_b_tag(self):
        @lab.wrap_in_b_tag
        def str_f(n):
            return 'xd' * n

        result = str_f(4)
        self.assertEqual(result, "<b>xdxdxdxd</b>")

    def test_square_dec(self):
        decorated = lab.square_dec(lab.max_num)
        a, b, c = 9, 2, 5
        result = decorated(a, b, c)
        self.assertEqual(result, 81)

    def test_upper(self):
        decorated = lab.upper(lab.str_reverse)
        s = "Всем привет!"
        result = decorated(s)
        self.assertEqual(result, "!ТЕВИРП МЕСВ")

    @mock.patch("sys.stdout", new_callable=io.StringIO)
    def test_log_args(self, stdout):
        @lab.log_args
        def test_f(a, b, inv=False):
            prod = a * b
            return prod if not inv else 1 / prod
        
        args = (4, 5)
        kwargs = { "inv": False }
        n = test_f(*args, **kwargs)

        self.assertEqual(
            stdout.getvalue(),
            f'Arguments: {args}\nKeyword arguments: {kwargs}\n'
        )

    def test_grange(self):
        lst = list(lab.grange(23, 37))
        self.assertEqual(
            lst, 
            [23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37]
        )

    def test_grange_step(self):
        lst = list(lab.grange_step(5, 37, 4))
        self.assertEqual(
            lst,
            [5, 9, 13, 17, 21, 25, 29, 33, 37]
        )


    def test_square(self):
        lst = [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3]
        result = list(lab.square(lst))
        self.assertEqual(
            result,
            [9, 0, 1, 9, 0, 16, 9, 9, 16, 3136, 36, 1, 9]
        )
        
    def test_grange_func(self):
        def step_f(n):
            return 2 * n
        
        result = list(lab.grange_func(0, 100, step_f))
        self.assertEqual(
            result,
            [0, 0, 2, 6, 12, 20, 30, 42, 56, 72]
        )



if __name__ == "__main__":
    main()
