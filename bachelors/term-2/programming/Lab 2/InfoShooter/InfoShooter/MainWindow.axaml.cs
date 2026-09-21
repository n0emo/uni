using System;
using System.Threading.Tasks;
using Avalonia.Controls;
using Avalonia.Interactivity;
using Avalonia.Layout;
using Avalonia.Threading;

namespace InfoShooter;

public partial class MainWindow : Window
{
    private DispatcherTimer? _timer;
    private TimeSpan _remainingTime;
    private TimeSpan _interval = new(0, 0, 0, 1);
    
    private TimeSpan _buttonSpawnInterwal;
    private TimeSpan _buttonRemoveInterval;
    private DispatcherTimer? _buttonTimer;
    
    private int _previousScore;
    
    private int _score;
    private int Score
    {
        get => _score;
        set
        {
            _score = value;
            ScoreLabel.Content = $"Score: {_score}";
        }
    }

    public MainWindow()
    {
        InitializeComponent();

        Score = 0;
    }

    private string GetTimeString(TimeSpan time)
    {
        return time.ToString("g");
    }

    private void StartButtonClick(object sender, RoutedEventArgs args)
    {

        Reset();

        _remainingTime = new TimeSpan(0, 0, 30);
        
        _timer = new DispatcherTimer(_interval,
            DispatcherPriority.Normal,
            delegate
            {
                TimerLabel.Content = GetTimeString(_remainingTime);
                if(_remainingTime <= TimeSpan.Zero)
                {
                    Reset();
                    MainCanvas.Children.Add(new Label()
                    {
                        VerticalAlignment = VerticalAlignment.Center,
                        HorizontalAlignment = HorizontalAlignment.Center,
                        FontSize = 48,
                        Content = $"Score : {_previousScore}"
                    });
                }
                _remainingTime = _remainingTime.Subtract(_interval);
            });
        
        _buttonSpawnInterwal = new(0, 0, 0, 0, (int)(2500 / DifficultySlider.Value));
        _buttonRemoveInterval = new(0, 0, 0, 0, (int)(7500 / DifficultySlider.Value));
        _buttonTimer = new DispatcherTimer(_buttonSpawnInterwal,
            DispatcherPriority.Normal,
            SpawnRandomButton);
        
        SpawnRandomButton(null, EventArgs.Empty);
        _timer.Start();
        _buttonTimer.Start();
    }

    private async void SpawnRandomButton(object? sender, EventArgs eventArgs)
    {
        Button button = new Button()
        {
            Height = 50,
            Width = 50,
            Content = "X",
            VerticalContentAlignment = VerticalAlignment.Center,
            HorizontalContentAlignment = HorizontalAlignment.Center,
            IsVisible = true,
            ClickMode = ClickMode.Press
        };
        button.Click += RandomButtonClick;
        MainCanvas.Children.Add(button);
        var top = (int)MainCanvas.Bounds.Height;
        var left = (int)MainCanvas.Bounds.Width;
        Canvas.SetTop(button, Random.Shared.Next(50, top - 100));
        Canvas.SetLeft(button, Random.Shared.Next(50, left - 100));

        await Task.Delay(_buttonRemoveInterval);
        if (MainCanvas.Children.Contains(button))
        {
            MainCanvas.Children.Remove(button);
        }
    }

    private void RandomButtonClick(object? sender, RoutedEventArgs args)
    {
        if (sender is not Button senderButton) return;
        MainCanvas.Children.Remove(senderButton);
        Score++;
    }

    private void Reset()
    {
        _previousScore = _score;
        _timer?.Stop();
        _buttonTimer?.Stop();
        Score = 0;
        MainCanvas.Children.Clear();
    }
}
