using System;
using System.IO;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using Microsoft.Win32;

namespace SovietTextEditor
{
    /// <summary>
    ///     Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow
    {
        private string _path;

        private bool _saved = true;

        private const string MUSIC_DIRECTORY = @"Assets\Music";

        private MediaPlayer _mediaPlayer = new MediaPlayer();

        public MainWindow()
        {
            InitializeComponent();
        }

        private void SaveProposal()
        {
            if (_saved) return;

            var result = MessageBox.Show(
                "Текущий файл не сохранён. Хотите его сохранить?",
                "Сохранение",
                MessageBoxButton.YesNo,
                MessageBoxImage.Warning);
            
            if (result == MessageBoxResult.Yes) Save();
        }

        private void CommandOpenExecuted(object sender, ExecutedRoutedEventArgs e)
        {
            SaveProposal();
            var openFileDielog = new OpenFileDialog();
            if (openFileDielog.ShowDialog() == false) return;
            _path = openFileDielog.FileName;
            MainTextBox.Text = File.ReadAllText(_path);
        }

        private void Save()
        {
            if (_path == null)
            {
                SaveAs();
                return;
            }

            File.WriteAllText(_path, MainTextBox.Text);
            _saved = true;
        }

        private void CommandSaveExecute(object sender, ExecutedRoutedEventArgs e)
        {
            Save();
        }

        private void SaveAs()
        {
            var saveFileDialog = new SaveFileDialog
            {
                Filter = "Text file (*.txt)|*.txt"
            };
            if (saveFileDialog.ShowDialog() == false) return;
            _path = saveFileDialog.FileName;
            File.WriteAllText(_path, MainTextBox.Text);
            _saved = true;
        }

        private void CommandSaveasExecute(object sender, ExecutedRoutedEventArgs e)
        {
            SaveAs();
        }

        private void CommandNewExecute(object sender, ExecutedRoutedEventArgs e)
        {
            SaveProposal();
            _path = null;
            MainTextBox.Clear();
        }

        private void MainTextBox_OnTextChanged(object sender, TextChangedEventArgs e)
        {
            _saved = false;
        }

        private void CommandCloseExecute(object sender, ExecutedRoutedEventArgs e)
        {
            Application.Current.Shutdown();
        }

        private void MainWindow_OnClosed(object sender, EventArgs e)
        {
            SaveProposal();
        }

        private void PlayMusic(string fileName)
        {
            _mediaPlayer.Stop();
            _mediaPlayer.Open(new Uri($@"{MUSIC_DIRECTORY}\{fileName}", UriKind.Relative));
            _mediaPlayer.Volume = 1;
            _mediaPlayer.Play();
        }
        
        private void USSRButtonClick(object sender, RoutedEventArgs e)
        {
            PlayMusic("Гимн СССР.mp3");
        }

        private void MainWindowLoaded(object sender, RoutedEventArgs e)
        {
            string[] songs = Directory.GetFiles(MUSIC_DIRECTORY)
                .Select(s => s.Split('\\').Last())
                .ToArray();

            foreach (var song in songs)
            {
                var menuItem = new MenuItem()
                {
                    Header = song.Substring(0, song.Length - 4),
                };
                string songName = song;
                menuItem.Click += (o, args) => PlayMusic(songName);
                MusicMenu.Items.Add(menuItem);
            }

            MusicMenu.Items.Add(new Separator());

            var stopMenuItem = new MenuItem()
            {
                Header = "Остановить музыку"
            };
            stopMenuItem.Click += (o, args) => _mediaPlayer.Stop();

            MusicMenu.Items.Add(stopMenuItem);
        }
    }
}