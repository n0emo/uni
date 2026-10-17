using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Text;

class Program
{
    // Контрольные суммы и хэш-функции
    public static string CalculateHash(string data)
    {
        using (SHA256 sha256 = SHA256.Create())
        {
            byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(data));
            StringBuilder builder = new StringBuilder();
            foreach (byte b in bytes)
            {
                builder.Append(b.ToString("x2"));
            }
            return builder.ToString();
        }
    }

    // Проверка целостности данных
    public static bool VerifyIntegrity(string data, string expectedHash)
    {
        string actualHash = CalculateHash(data);
        return actualHash == expectedHash;
    }

    // Резервное копирование и восстановление
    public static void BackupData(string data)
    {
        string backupDir = "backup";
        if (!Directory.Exists(backupDir))
        {
            Directory.CreateDirectory(backupDir);
        }

        string backupFile = Path.Combine(backupDir, "data_backup.txt");

        try
        {
            File.WriteAllText(backupFile, data);
            Console.WriteLine($"Данные сохранены в резервную копию: {backupFile}");
        }
        catch (IOException e)
        {
            Console.WriteLine($"Ошибка при сохранении резервной копии: {e.Message}");
        }
    }

    public static string RestoreData()
    {
        string backupFile = Path.Combine("backup", "data_backup.txt");

        try
        {
            string restoredData = File.ReadAllText(backupFile);
            Console.WriteLine($"Данные восстановлены из резервной копии: {restoredData}");
            return restoredData;
        }
        catch (IOException e)
        {
            Console.WriteLine($"Ошибка при восстановлении данных из резервной копии: {e.Message}");
            return null;
        }
    }

    // Правила разрешения конфликтов
    public static string ResolveConflict(string data1, string data2, DateTime timestamp1, DateTime timestamp2)
    {
        return timestamp1 > timestamp2 ? data1 : data2;
    }

    // Голосование и консенсус
    public static string VoteForData(List<string> dataList)
    {
        Dictionary<string, int> votes = new Dictionary<string, int>();
        foreach (string data in dataList)
        {
            string hashValue = CalculateHash(data);
            if (votes.ContainsKey(hashValue))
            {
                votes[hashValue]++;
            }
            else
            {
                votes[hashValue] = 1;
            }
        }

        int maxVotes = 0;
        string consensusData = null;
        foreach (var kvp in votes)
        {
            if (kvp.Value > maxVotes)
            {
                maxVotes = kvp.Value;
                consensusData = dataList.Find(data => CalculateHash(data) == kvp.Key);
            }
        }

        return consensusData; // Если нет консенсуса, вернет null
    }

    static void Main(string[] args)
    {
        // Пример использования
        string data = "Hello World!";
        string hashValue = CalculateHash(data);
        Console.WriteLine($"Хэш данных: {hashValue}");

        // Резервное копирование и восстановление
        BackupData(data);
        string restoredData = RestoreData();

        // Проверка целостности данных
        if (VerifyIntegrity(data, hashValue))
        {
            Console.WriteLine("Данные целостны");
        }
        else
        {
            Console.WriteLine("Данные повреждены");
        }

        // Разрешение конфликтов
        string data1 = "Привет, мир!";
        string data2 = "Здравствуй, мир!";
        DateTime timestamp1 = DateTime.Now;
        DateTime timestamp2 = timestamp1.AddSeconds(10);
        string resolvedData = ResolveConflict(data1, data2, timestamp1, timestamp2);
        Console.WriteLine($"Разрешенные данные: {resolvedData}");
        // Голосование и консенсус
        List<string> dataList = new List<string> { "Привет, мир!", "Здравствуй, мир!", "Привет, мир!" };
        string consensusData = VoteForData(dataList);
        Console.WriteLine($"Данные, выбранные консенсусом: {consensusData}");
    }
}
