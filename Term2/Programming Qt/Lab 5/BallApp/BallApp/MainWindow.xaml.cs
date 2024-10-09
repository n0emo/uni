using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Threading;

namespace BallApp
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private Button _restartButton;

        private Canvas _mainCanvas;

        private Ball _ball;
        private Ellipse _ellipse;
        private TimeSpan _refreshRate = new(0, 0, 0, 0, 20);

        private DispatcherTimer? _timer;
        
        
        public MainWindow()
        {
            InitializeComponent();
        }
        
        private void StartButtonClick(object sender, RoutedEventArgs e)
        {
            InitializeSimulation();
            
            MainPanel.Children.Add(_restartButton);
            MainPanel.Children.Add(_mainCanvas);
            _mainCanvas.Children.Add(_ellipse);
            
            _timer.Start();
        }

        private void InitializeSimulation()
        {
            InitializeDock();
            InitializeBall();
            Restart();
        }

        private void Restart()
        {
            _timer?.Stop();
            InitializeBall();
            _timer = new DispatcherTimer(_refreshRate, DispatcherPriority.Normal, (sender, args) =>
                {
                    _ball.Move();
                    _ball.SetCanvasPosition();
                }, 
                Dispatcher);
        }

        private void InitializeBall()
        {
            _ball = new Ball()
            {
                Canvas = _mainCanvas,
                Acceleration = -0.3,
                SpeedX = 5,
                SpeedY = 0,
                X = 100,
                Y = 200,
                Ellipse = _ellipse
            };
        }

        private void InitializeDock()
        {
            MainPanel.Children.Remove(StartButton);
            _restartButton = new Button()
            {
                Content = "Запустить заново",
                VerticalAlignment = VerticalAlignment.Top,
                HorizontalAlignment = HorizontalAlignment.Left,
                Margin = new Thickness(20)
            };
            _restartButton.Click += (sender, args) => Restart();

            _mainCanvas = new Canvas()
            {
                VerticalAlignment = VerticalAlignment.Stretch,
                HorizontalAlignment = HorizontalAlignment.Stretch,
                Background = new SolidColorBrush(Colors.Red),
                Margin = new Thickness(20)
            };

            DockPanel.SetDock(_restartButton, Dock.Top);
            DockPanel.SetDock(_mainCanvas, Dock.Top);

            _ellipse = new Ellipse()
            {
                Width = 20,
                Height = 20,
                Fill = new SolidColorBrush(Colors.Yellow)
            };
        }
    }
}