from unittest import TestCase, main

import arithmetic
import lists
import strings
import area
import dicts
import encapsulation

class TestArithmetic(TestCase):
    def test_sum(self):
        a, b = 4, 7
        self.assertEqual(arithmetic.sum(a, b), a + b)

    def test_sub(self):
        a, b = 4, 7
        self.assertEqual(arithmetic.sub(a, b), a - b)

    def test_mul(self):
        a, b = 4, 7
        self.assertEqual(arithmetic.mul(a, b), a * b)

class TestLists(TestCase):
    def test_in_list(self):
        lst = [4, 6, 1, 2]
        self.assertTrue(lists.in_list(lst, 4))
        self.assertFalse(lists.in_list(lst, 9))

    def test_list_count(self):
        lst = [3, 2, 4, 0, 3, 1, 2, 3]
        result = lists.list_count(lst, 3)
        self.assertEqual(result, 3)


class TestStrings(TestCase):
    def test_is_palindrome(self):
        s1 = "шалаш"
        self.assertTrue(strings.is_palindrome(s1))

        s2 = "шашал"
        self.assertFalse(strings.is_palindrome(s2))

    def test_str_len(self):
        s = "Privet"
        result = strings.str_len(s)
        self.assertEqual(result, 6)

    def test_str_lower(self):
        s = "Privet"
        result = strings.str_lower(s)
        self.assertEqual(result, "privet")


class TestDicts(TestCase):
    def test_dict_len(self):
        dct = {1: 4, 2: 5, 7: 5}
        result = dicts.dict_len(dct)
        self.assertEqual(result, 3)

    def test_key_in(self):
        dct = {1: 4, 2: 5, 7: 5}
        self.assertTrue(dicts.key_in(dct, 1))
        self.assertFalse(dicts.key_in(dct, 3))

class TestArea(TestCase):
    epsilon: float = 0.0001

    def test_area_of_circle(self):
        radius = 5
        result = area.area_of_circle(radius)
        self.assertLess(abs(78.53981634 - result), self.epsilon)

    def test_area_of_rectangle(self):
        a, b = 4, 6
        result = area.area_of_rectangle(a, b)
        self.assertEqual(result, 24)

    def test_area_of_triangle(self):
        a, b, c = 3, 4, 5
        result = area.area_of_triangle(a, b, c)
        self.assertLess(abs(a * b / 2 - result), self.epsilon)


class TestEncapsulation(TestCase):
    def test_get_set(self):
        new = "xd"
        encapsulation.set_secret(new)
        self.assertEqual(encapsulation.get_secret(), new)

    def test_set_raises(self):
        new = 5
        with self.assertRaises(ValueError):
            encapsulation.set_secret(new) # type: ignore



if __name__ == "__main__":
    main()
