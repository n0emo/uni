/*
    Лабораторная работа № 1
    Создание и запуск простого графического приложения Java.
    Рисование стилизованного изображения в окне приложения.

    Задание
    1.1)     Изучение особенностей создания и выполнения
    простого графического приложения Java.
    1.2)     Изучение и применение методов классов java.awt.Component,
    java.awt.Graphics, java.awt.Font, java.awt.Color.
    1.3)     Работа с программами-примерами, приобретение навыков работы
    с документацией Java.
    1.4)     Рисование стилизованного изображения (заданного предмета)
    в компоненте типа Canvas, размещенном в окне приложения Java,
    а также текстовой информации об авторе и теме рисунка.

    Требования
    -    Включить в программу комментарий, содержащий фамилию студента
    и задание, а также другие необходимые комментарии.
    -    Использовать представительное множество разнообразных
    методов рисования класса Graphics.
    -    Использовать методы установки шрифта, цвета фона и цвета изображения.

    Для выполнения лабораторной работы изучите методы классов пакета AWT и
    примеры. При выполнении задания использовать материалы: 1.	Учебные
    материалы и примеры в папке «AWT_Работа с графикой, цветом, шрифтами». 2.
    Приложение GreetApplication.java с комментариями. 3.	Шилдт Г. Java 8.
    Полное руководство, 9-е изд. /Пер. с англ. – М.: ООО «И.Д. Вильямс», 2017. −
    Глава 25. Введение в библиотеку AWT: работа с окнами, графикой и текстом. –
    С. 885–922. 4.	Примеры выполнения лабораторной работы № 1:
         - Lr1.java (базовый пример);
         - Lab1.java (пример Г.А. Хамчичева, демонстрирующий
         использование объектно-ориентированного подхода);
         - Lr1_2D.java (пример П.О. Чурсина, демонстрирующий
         использование возможностей класса Graphics2D).
*/

import java.awt.*;

// Main класс, в котором находится логика создания окна.
public class Tux {
    private static final Dimension _windowSize = new Dimension(1000, 1000);

    public static void main(String[] args) {
        // Использование флагов командной строки для настройки
        boolean printAuthor = !arrayContains(args, "-n");
        boolean drawReference = arrayContains(args, "-r");

        // Создание холста с изображением
        Canvas canvas = new TuxCanvas(printAuthor, drawReference);

        // Создание окна и добавление в него холста
        Frame frame = new Frame();
        frame.add(canvas);
        frame.setSize(_windowSize);
        frame.setLocationRelativeTo(null);
        frame.setTitle("Linux Tux");
        frame.setVisible(true);
        frame.addWindowListener(new TuxWindowAdapter());
    }

    // Метод для проверки, находится ли элемент в массиве
    private static <T> boolean arrayContains(T[] array, T elem) {
        for (T e : array) {
            if (elem.equals(e)) {
                return true;
            }
        }
        return false;
    }
}
