from unittest import TestCase, main

import lab

# pylint: disable-all


class TestTask2(TestCase):
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


class TestTask3(TestCase):
    def test_new_str(self):
        str1 = lab.new_str("")
        self.assertEqual(str1, "")

        str2 = lab.new_str("x")
        self.assertEqual(str2, "")

        str3 = lab.new_str("xd")
        self.assertEqual(str3, "xdxd")

        str4 = lab.new_str("Really big string.")
        self.assertEqual(str4, "Reg.")


class TestTask4(TestCase):
    def test_replace_dollar(self):
        str1 = lab.str_replace_dollar("01234567", 3)
        self.assertEqual(str1, "012$4567")

        str2 = lab.str_replace_dollar("", 3)
        self.assertEqual(str2, "")

        str3 = lab.str_replace_dollar("Bigger str", 23)
        self.assertEqual(str3, "Bigger str")

        str4 = lab.str_replace_dollar("str", -23)
        self.assertEqual(str4, "str")


class TestTask5(TestCase):
    def test_str_reverse(self):
        str1 = lab.str_reverse("")
        self.assertEqual(str1, "")

        str2 = lab.str_reverse("123")
        self.assertEqual(str2, "321")


class TestTask6(TestCase):
    def test_count_symbols(self):
        symbols1 = lab.count_symbols("")
        self.assertEqual(symbols1, {})

        symbols2 = lab.count_symbols("google.com")
        self.assertEqual(
            symbols2, {"o": 3, "g": 2, "e": 1, "l": 1, ".": 1, "c": 1, "m": 1}
        )


class TestTask7(TestCase):
    def test_str_even_odd(self):
        strs1 = lab.str_even_odd("")
        self.assertEqual(strs1, ("", ""))

        strs2 = lab.str_even_odd("0123456789")
        self.assertEqual(strs2, ("02468", "13579"))


class TestTask8(TestCase):
    def test_str_remove(self):
        str1 = lab.str_remove("012345", 3)
        self.assertEqual(str1, "01245")


class TestTask9(TestCase):
    def test_str_to_lower_upper(self):
        result = lab.str_to_lower_upper("Some String with MIXED case.")
        self.assertEqual(
            result, ("some string with mixed case.", "SOME STRING WITH MIXED CASE.")
        )


class TestTask11(TestCase):
    def test_str_to_lower_upper(self):
        self.assertTrue(lab.str_contains("Bigger string", "ing"))
        self.assertFalse(lab.str_contains("Bigger string", "big"))


class TestTask12(TestCase):
    def test_str_most_frequent_symbol(self):
        char1 = lab.str_most_frequent_symbol("string with some symbols")
        self.assertEqual(char1, "s")

        char2 = lab.str_most_frequent_symbol("ggggeee")
        self.assertEqual(char2, "g")


class TestTask13(TestCase):
    def test_str_swap_case(self):
        str1 = lab.str_swap_case("String. With some MIXED cAsE.")
        self.assertEqual(str1, "sTRING. wITH SOME mixed CaSe.")


class TestTask14(TestCase):
    def test_list_sum_1(self):
        sum1 = lab.list_sum_1([])
        self.assertEqual(sum1, 0)

        sum2 = lab.list_sum_1([1, 2, 3, 4, 5])
        self.assertEqual(sum2, 15)

    def test_list_sum_2(self):
        sum1 = lab.list_sum_2([])
        self.assertEqual(sum1, 0)

        sum2 = lab.list_sum_2([1, 2, 3, 4, 5])
        self.assertEqual(sum2, 15)


class TestTask15(TestCase):
    def test_list_multiply(self):
        lst = [2, 4, 6, 9, 12]
        result = lab.list_multiply(lst, 3)
        self.assertEqual(result, [6, 12, 18, 27, 36])


class TestTask16(TestCase):
    def test_list_min_max(self):
        min_max_1 = lab.list_min_max([1, 6, 0, 3, -5, 34, 1])
        self.assertEqual(min_max_1, (-5, 34))


class TestTask17(TestCase):
    def test_list_min_max(self):
        lst = lab.list_distinct([1, 6, 0, 3, 6, 34, 1])
        self.assertEqual(sorted(lst), [0, 1, 3, 6, 34])


class TestTask18(TestCase):
    def test_list_copy_1(self):
        lst1 = [5, "2", True, [74, "pk"]]
        lst2 = lab.list_copy_1(lst1)
        self.assertEqual(lst1, lst2)

    def test_list_copy_2(self):
        lst1 = [5, "2", True, [74, "pk"]]
        lst2 = lab.list_copy_2(lst1)
        self.assertEqual(lst1, lst2)


class TestTask19(TestCase):
    def test_list_concat_1(self):
        lst1 = [4, 5, 6]
        lst2 = ["x", "y", "z"]
        lst3 = lab.list_concat_1(lst1, lst2)
        self.assertEqual(lst3, [4, 5, 6, "x", "y", "z"])

    def test_list_concat_2(self):
        lst1 = [4, 5, 6]
        lst2 = ["x", "y", "z"]
        lst3 = lab.list_concat_2(lst1, lst2)
        self.assertEqual(lst3, [4, 5, 6, "x", "y", "z"])


class TestTask20(TestCase):
    def test_replace(self):
        lst = [2, 5, 3, 8, 9]
        lab.list_replace(lst, 2)
        self.assertEqual(lst, [2, 5, 8, 3, 9])

    def test_replace_throw(self):
        lst = [2, 5, 3, 8, 9]
        with self.assertRaises(Exception):
            lab.list_replace(lst, -1)
        with self.assertRaises(Exception):
            lab.list_replace(lst, 4)
        with self.assertRaises(Exception):
            lab.list_replace(lst, 35)


class TestTask21(TestCase):
    def test_list_join(self):
        lst = [15, 23, 150]
        result = lab.list_join(lst)
        self.assertEqual(result, 1523150)


class TestTask24(TestCase):
    def test_dict_concat(self):
        dict1 = {"a": 6}
        dict2 = {"j": 53, "b": 2, "r": 64}
        dict3 = {"n": 5, "j": 23}
        result_dict = lab.dict_concat(dict1, dict2, dict3)
        self.assertEqual(
            result_dict, {"a": 6, "j": 23, "b": 2, "n": 5, "r": 64, "n": 5}
        )


class TestTask25(TestCase):
    def test_dict_contains_key(self):
        dct = {2: "two", 4: "xd", 7: "=-="}
        self.assertTrue(lab.dict_contains_key(dct, 2))
        self.assertFalse(lab.dict_contains_key(dct, 0))


class TestTask26(TestCase):
    def test_dict_remove_key(self):
        dct = {1: "a", 2: "b", 3: "c"}
        lab.dict_remove_key(dct, 2)
        self.assertEqual(dct, {1: "a", 3: "c"})


class TestTask27(TestCase):
    def test_dict_min_max_1(self):
        dct = {"Jose": 15, "Mason": 49, "Pablo": 23, "Gibraltar": 98, "Ganesha": 44}
        mn, mx = lab.dict_min_max(dct)  # pyright: ignore [reportGeneralTypeIssues]
        self.assertEqual((mn, mx), ("Jose", "Gibraltar"))


class TestTask29(TestCase):
    def test_tuple_add_element(self):
        tup1 = (1, 2, "x")
        tup2 = lab.tuple_add_element(tup1, True)
        self.assertEqual(tup2, (1, 2, "x", True))


class TestTask30(TestCase):
    def test_tuple_to_dict(self):
        lst = [1, 2, "BMW"]
        tup = lab.list_to_tuple(lst)
        self.assertEqual(tup, (1, 2, "BMW"))


class TestTask31(TestCase):
    def test_tuple_to_dict(self):
        dct1 = lab.tuple_to_dict((("a", 1), ("b", 2)))
        self.assertEqual(dct1, {"a": 1, "b": 2})

        dct2 = lab.tuple_to_dict(())
        self.assertEqual(dct2, {})


class TestTask32(TestCase):
    def test_count_tuples(self):
        count1 = lab.count_tuples([(2, 4), 8, "xd", (3,), (), [2]])
        self.assertEqual(count1, 3)

        count2 = lab.count_tuples([])
        self.assertEqual(count2, 0)


class TestTask34(TestCase):
    def test_set_add(self):
        st1 = {3, 6}
        lab.set_add(st1, 7)
        self.assertEqual(st1, {3, 6, 7})


class TestTask35(TestCase):
    def test_set_remove(self):
        st1 = {3, 6, 7}
        lab.set_remove(st1, 7)
        self.assertEqual(st1, {3, 6})


class TestTask37(TestCase):
    def test_set_union(self):
        set1 = {2, 44, 3}
        set2 = {7, 5, 3}
        set3 = lab.set_union(set1, set2)
        self.assertEqual(set3, {2, 3, 5, 7, 44})


class TestTask38(TestCase):
    def test_set_count_1(self):
        count1 = lab.set_count_1({2, 5, 6, 7})
        self.assertEqual(count1, 4)

        count2 = lab.set_count_1(set())
        self.assertEqual(count2, 0)

    def test_set_count_2(self):
        count1 = lab.set_count_2({2, 5, 6, 7})
        self.assertEqual(count1, 4)

        count2 = lab.set_count_2(set())
        self.assertEqual(count2, 0)


class TestTask39(TestCase):
    def test_set_contains(self):
        self.assertTrue(lab.set_contains({2, 4}, 4))
        self.assertFalse(lab.set_contains({2, 4}, 5))


class TestTask40(TestCase):
    def test_file_write(self):
        text = "Some test string"
        file_name = "test40.txt"
        lab.file_write(file_name, text)

        with open(file_name, "r") as file:
            same_text = file.read()
            self.assertEqual(text, same_text)


class TestTask41(TestCase):
    def test_file_read(self):
        text = "Some other text string"
        file_name = "test41.txt"
        with open(file_name, "w") as file:
            file.write(text)

        same_text = lab.file_read(file_name)
        self.assertEqual(text, same_text)


class TestTask43(TestCase):
    def test_file_get_n_last_strings(self):
        file_name = "test43.txt"
        n = 3
        lines = ["x1\n", "x2\n", "x3\n", "x4\n", "x5\n"]
        with open(file_name, "w") as file:
            file.writelines(lines)

        result = lab.file_get_last_n_strings(file_name, n)
        self.assertEqual(result, lines[-n:])


class TestTask44(TestCase):
    def test_file_newline_count(self):
        file_name = "test44.txt"
        text = "1\n2\n3\n87\n"
        count = text.count("\n")

        with open(file_name, "w") as file:
            file.write(text)

        same_count = lab.file_newline_count(file_name)
        self.assertEqual(count, same_count)


class TestTask45(TestCase):
    def test_file_most_frequent_word(self):
        file_name = "test45.txt"
        most_frequent = lab.file_most_frequent_word(file_name)
        self.assertEqual(most_frequent, "the")


class TestTask46(TestCase):
    def test_file_copy(self):
        src = "test46_src.txt"
        dest = "test46_dest.txt"
        text = "Not really important text just to test file copy in binary mode.\n"
        same_text = None

        with open(src, "w") as file:
            file.write(text)

        lab.file_copy(src, dest)

        with open(dest, "r") as file:
            same_text = file.read()

        self.assertEqual(text, same_text)


class TestTask47(TestCase):
    def test_dict_write_to_file_and_return_contents(self):
        dct = {"one": "Home", "two": "End", "three": "Ins"}
        file_name = "test47.txt"

        content = lab.object_write_to_file_and_return_contents(dct, file_name)
        self.assertEqual(dct, content)


class TestTask48(TestCase):
    def test_dict_write_to_file_and_return_contents(self):
        lst = ["one", "Home", "two", "End", "three", "Ins"]
        file_name = "test48.txt"

        content = lab.object_write_to_file_and_return_contents(lst, file_name)
        self.assertEqual(lst, content)


class TestTask49(TestCase):
    def test_file_serialize_and_return_content(self):
        obj = {"a": [5, 6, 2], "b": 5, "c": True}
        file_name = "test49.txt"
        content = lab.file_serialize_and_return_content(obj, file_name)
        content = content.replace(" ", "").replace("\n", "").replace("\t", "")
        self.assertEqual(content, r'{"a":[5,6,2],"b":5,"c":true}')


if __name__ == "__main__":
    main()
