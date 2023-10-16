import unittest

import lab


class TestTask2(unittest.TestCase):
    def test_str_len_1(self):
        len1 = lab.str_len_1("")
        self.assertEqual(len1, 0)

        len2 = lab.str_len_1("qe")
        self.assertEqual(len2, 2)

        len3 = lab.str_len_1("892738hd423d472d4j28379s8293yhfkhl34323hr23jrhk23jdn")
        self.assertEqual(len3, 52)

    def test_str_len_2(self):
        len1 = lab.str_len_2("")
        self.assertEqual(len1, 0)

        len2 = lab.str_len_2("qe")
        self.assertEqual(len2, 2)

        len3 = lab.str_len_2("892738hd423d472d4j28379s8293yhfkhl34323hr23jrhk23jdn")
        self.assertEqual(len3, 52)


class TestTask3(unittest.TestCase):
    def test_new_str(self):
        str1 = lab.new_str("")
        self.assertEqual(str1, "")

        str2 = lab.new_str("x")
        self.assertEqual(str2, "")

        str3 = lab.new_str("xd")
        self.assertEqual(str3, "xdxd")

        str4 = lab.new_str("Really big string.")
        self.assertEqual(str4, "Reg.")


class TestTask4(unittest.TestCase):
    def test_replace_dollar(self):
        str1 = lab.str_replace_dollar("01234567", 3)
        self.assertEqual(str1, "012$4567")

        str2 = lab.str_replace_dollar("", 3)
        self.assertEqual(str2, "")

        str3 = lab.str_replace_dollar("Bigger str", 23)
        self.assertEqual(str3, "Bigger str")

        str4 = lab.str_replace_dollar("str", -23)
        self.assertEqual(str4, "str")


class TestTask27(unittest.TestCase):
    def test_dict_min_max_1(self):
        dct = {"Jose": 15, "Mason": 49, "Pablo": 23, "Gibraltar": 98, "Ganesha": 44}
        mn, mx = lab.dict_min_max(dct)  # pyright: ignore [reportGeneralTypeIssues]
        self.assertEqual((mn, mx), ("Jose", "Gibraltar"))


if __name__ == "__main__":
    unittest.main()
