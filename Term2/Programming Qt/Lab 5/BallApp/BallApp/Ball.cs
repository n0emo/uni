using System.Windows.Controls;
using System.Windows.Shapes;

namespace BallApp;

public class Ball
{
    public required double X { get; set; }
    public required double Y { get; set; }
    
    public required double SpeedX { get; set; }
    public required double SpeedY { get; set; }

    public required Canvas Canvas { get; init; }
    
    public required double Acceleration { get; init; }
    
    public required Ellipse Ellipse { get; init; }

    public void Move()
    {
        SpeedY -= Acceleration;
        
        if (X + SpeedX > Canvas.ActualWidth - 20 || X + SpeedX < 0)
        {
            SpeedX *= -1;
        }
        X += SpeedX;

        if (Y + SpeedY > Canvas.ActualHeight - 20 || Y + SpeedY < 0)
        {
            SpeedY *= -1;
            SpeedY -= Acceleration;
        }
        Y += SpeedY;
    }

    public void SetCanvasPosition()
    {
        Canvas.SetTop(Ellipse, Y);
        Canvas.SetLeft(Ellipse, X);
    }
}