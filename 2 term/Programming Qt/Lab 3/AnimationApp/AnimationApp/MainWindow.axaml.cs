using System;
using System.Threading.Tasks;
using Avalonia.Controls;

namespace AnimationApp;

public partial class MainWindow : Window
{
    private TimeSpan _period = new (0, 0, 0, 40);
    private TimeSpan _refreshPeriod = new (0, 0, 0, 0, 20);
    private DateTime _startTime;

    private const double FUNC_A = 1;
    private const double FUNC_B = FUNC_A / (2 * Math.PI * FUNC_N);
    private const double FUNC_N = 10;

    public MainWindow()
    {
        InitializeComponent();
    }

    private void OnActivate(object? sender, EventArgs e)
    {
        _startTime = DateTime.Now;
        Canvas.SetBottom(HerbImage, 400);
        Canvas.SetRight(HerbImage, 200);
        HerbAnimationTask();
        PlanetAnimationTask();
    }

    private async Task HerbAnimationTask()
    {
        while (true)
        {
            var herbPos = HerbAnimationFunction(DateTime.Now - _startTime);
            Canvas.SetLeft(HerbImage, herbPos.X);
            Canvas.SetTop(HerbImage, herbPos.Y);
            await Task.Delay(_refreshPeriod);
        }
    }
    
    private async Task PlanetAnimationTask()
    {
        while (true)
        {
            var planetPos = PlanetAnimationFunction(DateTime.Now - _startTime);
            planetPos.X += Canvas.GetLeft(HerbImage) + 60;
            planetPos.Y += Canvas.GetTop(HerbImage) + 60;
            Canvas.SetLeft(HerbPlanet, planetPos.X);
            Canvas.SetTop(HerbPlanet, planetPos.Y);
            await Task.Delay(_refreshPeriod);
        }
    }

    private (double X, double Y) HerbAnimationFunction(TimeSpan time)
    {
        var ms = time.TotalMilliseconds % _period.TotalMilliseconds / _period.TotalMilliseconds;
        bool mirrorFlag = ms > 0.5;
        if (mirrorFlag) ms = 1 - ms;
        ms *= Math.PI * 2 * FUNC_N;
        var x = FUNC_B * ms * Math.Cos(ms) * Width * 0.5;
        var y = FUNC_B * ms * Math.Sin(ms) * Height * 1;
        if (mirrorFlag) y = -y;
        return (x + Width * 0.5 - 100, y + Height * 0.5 - 100);
    }

    private (double X, double Y) PlanetAnimationFunction(TimeSpan time)
    {
        var ms = time.TotalMilliseconds / _period.TotalMilliseconds * Math.PI * 8 * FUNC_N;
        var x = Math.Cos(ms);
        var y = Math.Sin(ms);
        return (x * Width * 0.1, y * Height * 0.2);
    }
}