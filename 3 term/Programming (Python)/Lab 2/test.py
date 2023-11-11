# pylint: skip-file

import io
from unittest import TestCase, main, mock

import lab


class LabTest(TestCase):
    def test_task_1(self):
        s = "Данная часть была посвящена больше синтаксису python и вопросам документации кода"
        result = lab.task_1(s)
        self.assertEqual(result, "Дна ат ыапсяеаблш иткиуpto  орсмдкмнаи оа")

    def test_task_2(self):
        s = "Данная часть была посвящена больше синтаксису python и вопросам документации кода"
        result = lab.task_2(s)
        self.assertEqual(result, "н слпв леаи n п кеио")

    def test_task_3(self):
        s = "Данная часть была посвящена больше синтаксису python и вопросам документации кода"
        result = lab.task_3(s)
        self.assertEqual(result, "наяатьыа сящабош стксуpyo иоромдомнти ка")

    @mock.patch("sys.stdout", new_callable=io.StringIO)
    def test_task_4_for(self, stdout):
        lab.task_4_for(10)
        self.assertEqual(stdout.getvalue(), "1 2 3 4 5 6 7 8 9 10 \n")

    @mock.patch("sys.stdout", new_callable=io.StringIO)
    def test_task_4_while(self, stdout):
        lab.task_4_while(10)
        self.assertEqual(stdout.getvalue(), "1 2 3 4 5 6 7 8 9 10 \n")

    @mock.patch("sys.stdout", new_callable=io.StringIO)
    def test_task_5_for(self, stdout):
        lab.task_5_for(-20, 20, 3)
        self.assertEqual(
            stdout.getvalue(), "-20 -17 -14 -11 -8 -5 -2 1 4 7 10 13 16 19 \n"
        )

    @mock.patch("sys.stdout", new_callable=io.StringIO)
    def test_task_5_while(self, stdout):
        lab.task_5_while(-20, 20, 3)
        self.assertEqual(
            stdout.getvalue(), "-20 -17 -14 -11 -8 -5 -2 1 4 7 10 13 16 19 \n"
        )

    def test_task_6_for(self):
        lst = [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3]
        result = lab.task_6_for(lst, 3)
        self.assertEqual(result, 5)

    def test_task_6_while(self):
        lst = [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3]
        result = lab.task_6_while(lst, 3)
        self.assertEqual(result, 5)

    def test_task_6_count(self):
        lst = [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3]
        result = lab.task_6_count(lst, 3)
        self.assertEqual(result, 5)

    def test_task_7_comp(self):
        s = "список доступных атрибутов"
        result = lab.task_7_comp(s)
        self.assertEqual(
            result,
            [
                "с",
                "п",
                "и",
                "с",
                "о",
                "к",
                " ",
                "д",
                "о",
                "с",
                "т",
                "у",
                "п",
                "н",
                "ы",
                "х",
                " ",
                "а",
                "т",
                "р",
                "и",
                "б",
                "у",
                "т",
                "о",
                "в",
            ],
        )

    def test_task_7_for(self):
        s = "список доступных атрибутов"
        result = lab.task_7_for(s)
        self.assertEqual(
            result,
            [
                "с",
                "п",
                "и",
                "с",
                "о",
                "к",
                " ",
                "д",
                "о",
                "с",
                "т",
                "у",
                "п",
                "н",
                "ы",
                "х",
                " ",
                "а",
                "т",
                "р",
                "и",
                "б",
                "у",
                "т",
                "о",
                "в",
            ],
        )

    def test_task_8(self):
        matrix = lab.task_8(3)
        self.assertEqual(matrix, [[1, 0, 0], [0, 1, 0], [0, 0, 1]])

    def test_task_9(self):
        lst = [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3]
        result = lab.task_9(lst)
        self.assertEqual(result, [3, 1, 6, 56, 4, 3, 3, 4, 0, 3, 1, 0, 3])

    @mock.patch("sys.stdout", new_callable=io.StringIO)
    def test_task_10(self, stdout):
        lab.task_10(1, 9, [5, 7])
        self.assertEqual(stdout.getvalue(), "1, 2, 3, 4, 6, 8, 9\n")

    def test_task_11_for(self):
        lst = [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3]
        result = lab.task_11_for(lst)  # type: ignore
        self.assertEqual(result, 87)

    def test_task_11_while(self):
        lst = [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3]
        result = lab.task_11_while(lst)  # type: ignore
        self.assertEqual(result, 87)

    def test_task_11_sum(self):
        lst = [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3]
        result = lab.task_11_sum(lst)  # type: ignore
        self.assertEqual(result, 87)

    def test_task_12(self):
        lst = [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3]
        result = lab.task_12(lst)
        self.assertEqual(result, 21)

    def test_task_13(self):
        lst = lab.task_13(23, 35)
        self.assertEqual(lst, [23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35])

    def test_task_14(self):
        lst = lab.task_14(3, 15, 4)
        self.assertEqual(lst, [3, 7, 11, 15])

    def tesk_task_15(self):
        def predicate(n):
            return n % 3 == 0

        lst = lab.task_15(3, 25, predicate)
        self.assertEqual(lst, [3, 6, 9, 12, 15, 18, 21, 24])

    def test_task_16(self):
        lst1 = [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3]
        lst2 = [2, 4, 7, 26, 33]
        result = lab.task_16(lst1, lst2)
        self.assertEqual(result, {3: 26, 0: 33, 1: 7})

    @mock.patch("sys.stdout", new_callable=io.StringIO)
    def test_task_17(self, stdout):
        lst = [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3]
        lab.task_17(lst)
        self.assertEqual(
            stdout.getvalue(),
            "1: 3\n2: 0\n3: 1\n4: 3\n5: 0\n6: 4\n7: 3\n8: 3\n9: 4\n10: 56\n11: 6\n12: 1\n13: 3\n",
        )

    def test_task_18(self):
        self.assertEqual(lab.task_18(1), "Winter")
        self.assertEqual(lab.task_18(5), "Spring")
        self.assertEqual(lab.task_18(6), "Summer")
        self.assertEqual(lab.task_18(10), "Autumn")

    def test_task_19(self):
        nums = [9, 2, 7]
        result = lab.task_19(nums)  # type: ignore
        self.assertEqual(result, 7)

    @mock.patch("sys.stdout", new_callable=io.StringIO)
    def test_task_20(self, stdout):
        lab.task_20(3)
        self.assertEqual(
            stdout.getvalue(),
            "3 * 1 = 3\n3 * 2 = 6\n3 * 3 = 9\n3 * 4 = 12\n3 * 5 = 15"
            + "\n3 * 6 = 18\n3 * 7 = 21\n3 * 8 = 24\n3 * 9 = 27\n",
        )


if __name__ == "__main__":
    main()
