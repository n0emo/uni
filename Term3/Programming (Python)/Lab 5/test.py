from typing import List
from unittest import TestCase, main, mock
from io import StringIO
import math

import arithmetic
import car
import objcount
import interfaces
import shapes
import cars
import shops
import animals
import properties
import models

# task 1
class TestSubsets(TestCase):
    def test_subsets(self):
        lst = [2, 4, 10, 1]
        subsets = arithmetic.SubSets(lst)
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

# task 2
class TestOperations(TestCase):
    def test_operations(self):
        a, b = 3, 6
        op = arithmetic.Operations(a, b)
        self.assertEqual(op.add(), a + b)
        self.assertEqual(op.sub(), a - b)
        self.assertEqual(op.mul(), a * b)
        self.assertEqual(op.div(), a / b)

# task 3
class TestCar(TestCase):
    @mock.patch("sys.stdout", new_callable=StringIO)
    def test_car(self, stdout):
        car1 = car.Car(100)
        car1.ride()
        car1.stop()
        self.assertEqual(
            stdout.getvalue(),
            "Поехали!\nОстановились!\n"
        )

# task 4
class TestRectangle(TestCase):
    def test_area(self):
        a, b = 4, 7
        rect = arithmetic.Rectangle(a, b)
        self.assertEqual(rect.area(), 28)

    def test_operations(self):
        r1 = arithmetic.Rectangle(10, 12)
        r2 = arithmetic.Rectangle(10, 12)
        r3 = arithmetic.Rectangle(5, 4)

        self.assertTrue(r1 == r2)
        self.assertFalse(r1 != r2)
        self.assertTrue(r1 > r3)
        self.assertTrue(r2 >= r1)
        self.assertTrue(r3 <= r2 <= r1)
        self.assertFalse(r1 < r3)

# task 5
class TestCarWithState(TestCase):
    @mock.patch("sys.stdout", new_callable=StringIO)
    def test_ride(self, stdout):
        car1 = car.CarWithState("Феррари")
        car1.display_state()
        car1.ride()
        car1.display_state()

        self.assertEqual(
            stdout.getvalue(),
            'Машина "Феррари" остановлена\nМашина "Феррари" едет\n'
        )

    @mock.patch("sys.stdout", new_callable=StringIO)
    def test_turns(self, stdout):
        car1 = car.CarWithState("Лада")
        car1.turn_left()
        car1.display_state()
        car1.ride()
        car1.turn_left()
        car1.display_state()
        car1.turn_right()
        car1.display_state()

        self.assertEqual(
            stdout.getvalue(),
            'Машина "Лада" остановлена\n' + 
            'Машина "Лада" поворачивает налево\n' + 
            'Машина "Лада" поворачивает направо\n'
        )

# task 6
class TestCounter(TestCase):
    def test_counter(self):
        c1 = objcount.Counter()
        c2 = objcount.Counter()
        c3 = objcount.Counter()
        c4 = objcount.Counter()
        c5 = objcount.Counter()
        c6 = objcount.Counter()

        self.assertEqual(objcount.Counter.count(), 6)

        del c2
        del c5
        del c6

        self.assertEqual(objcount.Counter.count(), 3)

# task 8
class TestShapes(TestCase):
    def test_area(self):
        shape_list = [
            shapes.Rectangle(2, 5),
            shapes.Square(10),
            shapes.Circle(4),
        ]

        self.assertEqual(shape_list[0].area(), 2 * 5)
        self.assertEqual(shape_list[1].area(), 10 * 10)
        self.assertEqual(shape_list[2].area(), math.pi * 4 * 4)

    def test_perimeter(self):
        shape_list: List[interfaces.ShapeBase] = [
            shapes.Rectangle(2, 5),
            shapes.Square(10),
            shapes.Circle(4),
        ]

        self.assertEqual(shape_list[0].perimeter(), 2 * (2 + 5))
        self.assertEqual(shape_list[1].perimeter(), 4 * 10)
        self.assertEqual(shape_list[2].perimeter(), math.pi * 2 * 4)

# task 9
class TestCars(TestCase):
    @mock.patch("sys.stdout", new_callable=StringIO)
    def test_drive(self, stdout):
        car_list: List[interfaces.CarBase] = [
            cars.SportCar("Феррари"),
            cars.AutoVaz(100)
        ]

        car_list[0].drive()
        self.assertEqual(
            stdout.getvalue(),
            "Need for speed!\n"
        )

        stdout.truncate(0)
        stdout.seek(0)
        
        car_list[1].drive()
        self.assertEqual(
            stdout.getvalue(),
            "AutoVaz Lastochka tronulsya...\n"
        )

    @mock.patch("sys.stdout", new_callable=StringIO)
    def test_stop(self, stdout):
        car_list: List[interfaces.CarBase] = [
            cars.SportCar("Феррари"),
            cars.AutoVaz(100)
        ]

        car_list[0].stop()
        self.assertEqual(
            stdout.getvalue(),
            "Sportcar 'Феррари' stopped! Why?\n"
        )

        stdout.truncate(0)
        stdout.seek(0)
        
        car_list[1].stop()
        self.assertEqual(
            stdout.getvalue(),
            "AutoVaz Lastochka ostanovilsya...\n"
        )
    
# task 10
class TestShops(TestCase):
    @mock.patch("sys.stdout", new_callable=StringIO)
    def test_shops(self, stdout):
        stall = shops.Stall("Арбуз", 10, 150)
        supermarket = shops.Supermarket({"Хлеб": interfaces.ShopItem("Хлеб", 10, 40)})

        stall.sell(4)
        supermarket.sell("Хлеб", 7)

        shop_list = [stall, supermarket]
        self.assertEqual([shop.margin for shop in shop_list], [600, 280])

        self.assertEqual(shop_list[0].items["Арбуз"].amount, 6)
        self.assertEqual(shop_list[1].items["Хлеб"].amount, 3)

# task 11
class TestAnimals(TestCase):
    @mock.patch("sys.stdout", new_callable=StringIO)
    def test_feed(self, stdout):
        animal_list: List[interfaces.AnimalBase] = [
            animals.Horse(),
            animals.Tiger()
        ]

        for animal in animal_list:
            animal.feed("apples", 20)

        self.assertEqual(
            stdout.getvalue(),
            "Horse just ate 20 amount of apples.\nTiger refused to eat apples.\n"
        )

    @mock.patch("sys.stdout", new_callable=StringIO)
    def test_make_sound(self, stdout):
        animal_list: List[interfaces.AnimalBase] = [
            animals.Horse(),
            animals.Tiger()
        ]

        for animal in animal_list:
            animal.make_sound()

        self.assertEqual(
            stdout.getvalue(),
            "Neigh!!!\nRoar!!!\n"
        )

# task 12
class TestPropertyHolder(TestCase):
    def test_propertyholder(self):
        (holder) = properties.PropertyHolder(1, "xd")
        self.assertEqual((holder.a, holder.b), (1, "xd"))
        holder.b = "lol"
        self.assertEqual((holder.a, holder.b), (1, "lol"))

# task 13
class TestIntNum(TestCase):
    def test_operations(self):
        a = arithmetic.IntNum(43)
        b = arithmetic.IntNum(10)

        self.assertEqual((a + b).value, 53)
        self.assertEqual((a - b).value, 33)
        self.assertEqual((a * b).value, 430)
        self.assertEqual((a // b).value, 4)

# task 14
class TestJsonFile(TestCase):
    def test_jsonfile(self):
        data = {"x": 4, "y": 8}
        file = models.JsonFile("test_task14.txt")

        file.write(data)

        s = file.read()
        self.assertEqual(s['x'], 4)
        self.assertEqual(s['y'], 8)

# task 15
class TestMaxBy(TestCase):
    def test_rect_area(self):
        rects: List[arithmetic.Rectangle] = [
            arithmetic.Rectangle(2, 5),
            arithmetic.Rectangle(9, 1),
            arithmetic.Rectangle(2, 2),
            arithmetic.Rectangle(8, 8),
            arithmetic.Rectangle(3, 4),
        ]

        result = arithmetic.MaxBy.rect_area().get(rects)
        self.assertEqual(result.area(), 64)

# task 16
class TestNumSysConverter(TestCase):
    def test_converter(self):
        bin_1 = "1101"
        conv_1 = arithmetic.NumSysConverter(bin_1, 2)
        self.assertEqual(conv_1.convert_to(10), "13")

        dec_2 = "531"
        conv_2 = arithmetic.NumSysConverter(dec_2, 10)
        self.assertEqual(conv_2.convert_to(2), "1000010011")

# task 17
class TestGcdFinder(TestCase):
    def test_gcd(self):
        finder = arithmetic.GcdFinder()
        finder.a = 3215
        finder.b = 1286
        self.assertEqual(finder.find(), 643)

# task 18
class TestQuadraticEquation(TestCase):
    def test_equation(self):
        equation = arithmetic.QuadraticEquation(1, -4, 3)
        self.assertEqual(equation.solve, (1, 3))

# task 19
class TestEmployee(TestCase):
    def test_employee(self):
        employee = models.Employee("John", 1500, "Devops")
        self.assertDictEqual(
            employee.to_dict(),
            {"name": "John", "salary": 1500, "department": "Devops"}
        )

if __name__ == "__main__":
    main()

