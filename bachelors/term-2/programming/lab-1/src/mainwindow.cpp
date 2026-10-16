#include "mainwindow.h"
#include "./ui_mainwindow.h"
#include <QDateTime>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    _timesClicked = 0;
    _clickPower = 1;
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_ClickMeButton_clicked()
{
    _timesClicked += _clickPower;
    QString text = "";
    text.append("Clicked ").append(QString::number(_timesClicked)).append(" times.");
    ui->ClickedLabel->setText(text);

    ui->clickedHistoryBox->append(QDateTime::currentDateTime().toString("[dd.MM.yyyy HH.mm.ss]").append(" - clicked ").append(QString::number(_clickPower)).append(" times."));
}

void MainWindow::on_pushButton_clicked()
{
    _timesClicked = 0;
    ui->ClickedLabel->setText("Clicked 0 times.");
    ui->powerSlider->setValue(1);
}

void MainWindow::on_powerSlider_valueChanged(int value)
{
    _clickPower = value;
    QString text = "";
    text.append("Click power: ").append(QString::number(_clickPower));
    ui->clickPowerLabel->setText(text);
}

