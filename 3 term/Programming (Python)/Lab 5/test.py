from unittest import TestCase, main
import arithmetic

class TestSubsets(TestCase):
    def test_subsets(self):
        lst = [2, 4, 10, 1]
        subsets = arithmetic.SubSets(lst);
        self.assertCountEqual(
            sorted(subsets.get_subsets()),
            sorted([
                [], [2], [4], [10], [1],
                [2, 4], [2, 10], [2, 1],
                [4, 10], [4, 1], [10, 1],
                [2, 4, 10], [2, 4, 1],
                [2, 10, 1], [4, 10, 1],
                [2, 4, 10, 1]
            ]) 
        )


if __name__ == "__main__":
    main()

