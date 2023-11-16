from unittest import TestCase, main

import arithmetic 
import functions # pyright: ignore
import perror # pyright: ignore

class TestPair(TestCase):
    def test_pair_operations(self):
        pair = arithmetic.Pair(2, 4)
        self.assertEqual(pair.add(), 6.0)
        self.assertEqual(pair.sub(), -2.0)
        self.assertEqual(pair.mul(), 8.0)
        self.assertEqual(pair.div(), 0.5)

    def test_pair_error(self):
        pair = arithmetic.Pair(2, 0)

        with self.assertRaises(ValueError):
            pair.add()

        with self.assertRaises(ValueError):
            pair.sub()

        with self.assertRaises(ValueError):
            pair.mul()

        with self.assertRaises(ValueError):
            pair.div()

class TestSafePair(TestCase):
    def test_safe_pair(self):
        pair = arithmetic.Pair(2, 4)
        safe_pair = arithmetic.SafePair(pair)
        self.assertEqual(pair.mul(), safe_pair.mul())
        self.assertEqual(pair.div(), safe_pair.div())

    def test_safe_pair_with_zero(self):
        pair = arithmetic.Pair(0, 5)
        safe_pair = arithmetic.SafePair(pair)
        self.assertEqual(safe_pair.mul(), 5.0)
        self.assertEqual(safe_pair.div(), 0.2)
    
    
class TestFunctions(TestCase):
    def test_str_upper(self):
        s = "Xd with Str"
        result = functions.str_upper(s)
        self.assertEqual(result, "XD WITH STR")

    def test_str_upper_error(self):
        with self.assertRaises(ValueError):
            functions.str_upper("")

        with self.assertRaises(ValueError):
            functions.str_upper(5) # type: ignore

    def test_in_list(self):
        lst = [2, 5, 6]
        self.assertTrue(functions.in_list(lst, 2))
        self.assertFalse(functions.in_list(lst, 7))

    def test_in_list_error(self):
        with self.assertRaises(ValueError):
            functions.in_list([], 5)

        with self.assertRaises(ValueError):
            functions.in_list(5, 3) # type: ignore


class TestRussianPError(TestCase):
    def test_russian_p_error(self):
        self.assertEqual(perror.str_lower("Str"), "str")
        
        with self.assertRaises(perror.RussianPError):
            perror.str_lower("привет")

if __name__ == "__main__":
    main()
