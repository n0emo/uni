ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Базы данных и управление данными»#strong[]

#strong[ОТЧЁТ]

#strong[ПО ПРАКТИЧЕСКОЙ РАБОТЕ № 4]

#strong[«Обеспечение целостности данных и разрешение противоречий»]

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [Выполнили студенты

    Факультет: АИТ

    Группа: ИВБ-211

    ], [Ахмедов Х.А.

    Кот Н.Д.

    Шефнер А.

    ],
    [Проверил:

    Профессор кафедры

    «Информационные и вычислительные

    системы

    ], [Хомоненко А.Д.],
  )]
  , kind: table
  )

#strong[Санкт-Петербург]

#strong[2024]

Оценочный лист результатов ПР № 4

Ф.И.О. студентов :#emph[Ахмедов Х.А., Кот Н.Д., Шефнер А.]

Группа \_\_\_\_\_\_\_\_\_\_\_\_\_#emph[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

Профессор кафедры

«Информационные и вычислительные

системы»#strong[ Хомоненко А.Д. «\_\_» \_\_\_\_\_\_\_\_\_\_2024 г. ]

#strong[Цель]

Рассмотреть методы обеспечения целостности данных в информационных
системах. Продемонстрировать варианты разрешения данных при их
противоречии, используя тестовые сценарии. Проанализировать
эффективность каждого метода.

#strong[Ход работы]

Методы разрешения конфликтов:

- Контрольные суммы и хэш-функции:

  - Контрольные суммы (например, CRC, MD5, SHA-256) позволяют проверять,
    не были ли данные повреждены или изменены.

- Резервное копирование и восстановление:

  - Регулярное резервное копирование данных позволяет восстанавливать их
    в случае повреждения или потери.
  - Процедуры восстановления должны быть тщательно протестированы, чтобы
    гарантировать, что данные будут восстановлены корректно.

- Проверка целостности данных:

  - Периодическая проверка целостности данных, например, с помощью
    контрольных сумм, позволяет выявлять и исправлять ошибки.
  - Автоматизированные процедуры проверки могут быть встроены в систему.

- Для разрешения противоречий в данных можно использовать следующие
  подходы:

+ Правила разрешения конфликтов:

  #block[
  #set enum(numbering: "a.", start: 1)
  + Определение приоритетов между источниками данных (например,
    последнее обновление имеет наивысший приоритет).
  + Использование временных меток для определения актуальности данных.
  ]

+ Голосование и консенсус:

  #block[
  #set enum(numbering: "a.", start: 1)
  + Если данные поступают из нескольких источников, можно использовать
    голосование для определения наиболее достоверного значения.
  + Алгоритмы консенсуса (например, Paxos, Raft) позволяют достичь
    согласия между узлами системы.
  ]

+ Ручное разрешение конфликтов:

  #block[
  #set enum(numbering: "a.", start: 1)
  + В некоторых случаях может потребоваться ручное вмешательство
    экспертов для разрешения противоречий
  ]

#strong[Реализация на языке C\#]

using System;

using System.Collections.Generic;

using System.IO;

using System.Security.Cryptography;

using System.Text;

class Program

{

\/\/ Контрольные суммы и хэш-функции

public static string CalculateHash(string data)

{

using (SHA256 sha256 = SHA256.Create())

{

byte\[\] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(data));

StringBuilder builder = new StringBuilder();

foreach (byte b in bytes)

{

builder.Append(b.ToString(\"x2\"));

}

return builder.ToString();

}

}

\/\/ Проверка целостности данных

public static bool VerifyIntegrity(string data, string expectedHash)

{

string actualHash = CalculateHash(data);

return actualHash == expectedHash;

}

\/\/ Резервное копирование и восстановление

public static void BackupData(string data)

{

string backupDir = \"backup\";

if (!Directory.Exists(backupDir))

{

Directory.CreateDirectory(backupDir);

}

string backupFile = Path.Combine(backupDir, \"data\_backup.txt\");

try

{

File.WriteAllText(backupFile, data);

Console.WriteLine(\$\"Данные сохранены в резервную копию:
{backupFile}\");

}

catch (IOException e)

{

Console.WriteLine(\$\"Ошибка при сохранении резервной копии:
{e.Message}\");

}

}

public static string RestoreData()

{

string backupFile = Path.Combine(\"backup\", \"data\_backup.txt\");

try

{

string restoredData = File.ReadAllText(backupFile);

Console.WriteLine(\$\"Данные восстановлены из резервной копии:
{restoredData}\");

return restoredData;

}

catch (IOException e)

{

Console.WriteLine(\$\"Ошибка при восстановлении данных из резервной
копии: {e.Message}\");

return null;

}

}

\/\/ Правила разрешения конфликтов

public static string ResolveConflict(string data1, string data2,
DateTime timestamp1, DateTime timestamp2)

{

return timestamp1 \> timestamp2 ? data1 : data2;

}

\/\/ Голосование и консенсус

public static string VoteForData(List\<string\> dataList)

{

Dictionary\<string, int\> votes = new Dictionary\<string, int\>();

foreach (string data in dataList)

{

string hashValue = CalculateHash(data);

if (votes.ContainsKey(hashValue))

{

votes\[hashValue\]++;

}

else

{

votes\[hashValue\] = 1;

}

}

int maxVotes = 0;

string consensusData = null;

foreach (var kvp in votes)

{

if (kvp.Value \> maxVotes)

{

maxVotes = kvp.Value;

consensusData = dataList.Find(data =\> CalculateHash(data) == kvp.Key);

}

}

return consensusData; /\/ Если нет консенсуса, вернет null

}

static void Main(string\[\] args)

{

\/\/ Пример использования

string data = \"Hello World!\";

string hashValue = CalculateHash(data);

Console.WriteLine(\$\"Хэш данных: {hashValue}\");

\/\/ Резервное копирование и восстановление

BackupData(data);

string restoredData = RestoreData();

\/\/ Проверка целостности данных

if (VerifyIntegrity(data, hashValue))

{

Console.WriteLine(\"Данные целостны\");

}

else

{

Console.WriteLine(\"Данные повреждены\");

}

\/\/ Разрешение конфликтов

string data1 = \"Привет, мир!\";

string data2 = \"Здравствуй, мир!\";

DateTime timestamp1 = DateTime.Now;

DateTime timestamp2 = timestamp1.AddSeconds(10);

string resolvedData = ResolveConflict(data1, data2, timestamp1,
timestamp2);

Console.WriteLine(\$\"Разрешенные данные: {resolvedData}\");

\/\/ Голосование и консенсус

List\<string\> dataList = new List\<string\> { \"Привет, мир!\",
\"Здравствуй, мир!\", \"Привет, мир!\" };

string consensusData = VoteForData(dataList);

Console.WriteLine(\$\"Данные, выбранные консенсусом: {consensusData}\");

}

}

#strong[Результат]

#box(image("./assets/100000010000033E000000D2AB9F8868.png", height: 1.6437in, width: 6.4965in))

#strong[Рассмотрим несколько методов]

#strong[Контрольные суммы:]

С помощью CalculateHash, VerifyIntegrity происходит проверка контрольных
сумм ожидаемого и полученного хэша.

#strong[Резервное копирование и восстановление:]

backupData, restoreData сохраняют и восстанавливают данные
соответственно

#strong[Методы разрешения конфликтов:]

В ResolveConflict мы рассматриваем метод сравнения данных с
использованием временных меток.

В VoteForData рассматривается метод голосования и консенсуса, здесь мы
можем хранить несколько контрольных сумм данных, между которыми после
будет выбираться подходящая.

#strong[Вывод]

#strong[]

Эффективность контрольных сумм давно подтверждена, и они широко
применяются в различных областях. Резервное копирование и восстановление
также являются достаточно эффективными методами, которые можно дополнить
предыдущим подходом. На мой взгляд, методы голосования и консенсуса
подходят только для данных с небольшими отличиями. Для их эффективности
необходимо наличие эталонов данных, а также в случае отсутствия явного
большинства \"голосов\" за какой-либо вариант консенсус не будет
достигнут, что затруднит определение наиболее достоверных данных.
