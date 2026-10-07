ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Сети и телекоммуникации»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ №3]

#strong[“Знакомство с командами IOS”]

#figure(
  align(center)[#table(
    columns: (49.12%, 49.1%),
    align: (auto,auto,),
    table.header([Выполнил студент

      Факультет: АИТ

      Группа: ИВБ-211

      ], table.cell(align: right)[Шефнер А.

      ],),
    table.hline(),
    [Проверил:

    ], table.cell(align: right)[Молодкин И.А.

    ],
  )]
  , kind: table
  )

#strong[Санкт-Петербург]

#strong[2025 \ ]

#strong[Цель работы]

Познакомиться с командами IOS

#strong[Ход работы]

#strong[\1. Основные команды сетевого устройства]

#strong[Установка имени хоста и пароля]

Router\>

#strong[Router\>enable]

#strong[Router\#config]

Configuring from terminal, memory, or network \[terminal\]?

Enter configuration commands, one per line. End with CNTL/Z.

#strong[Router(config)\#hostname Router1]

#strong[Router1(config)\#enable password parol]

#strong[Проверка пароля]

Router1\>

#strong[Router1\>enable]

Password:

Router1\#

#strong[\2. Команда show]

#strong[Router1\#show clock]

\*1:6:11.643 UTC Mon Mar 1 1993

#strong[Router1\#show flash]

System flash directory:

File Length Name/status

3 486899872isr4300-universalk9.16.06.04.SPA.bin

2 28282 sigdef-category.xml

1 227537 sigdef-default.xml

\[487155691 bytes used, 2761893909 available, 3249049600 total\]

3.17338e+06K bytes of processor board System flash (Read/Write)

#strong[Router1\#show history]

enable

hostname Router1

disable

enable

config

disable

enable

show clock

show flash

show history

Router1\#show hosts

Default Domain is not set

Name/address lookup uses domain service

Name servers are 255.255.255.255

Codes: UN - unknown, EX - expired, OK - OK, ?? - revalidate

temp - temporary, perm - permanent

NA - Not Applicable None - Not defined

Host Port Flags Age Type Address(es)

Router1\#show interfaces

GigabitEthernet0/0/0 is administratively down, line protocol is down
(disabled)

Hardware is ISR4331-3x1GE, address is 0030.a380.4401 (bia
0030.a380.4401)

MTU 1500 bytes, BW 1000000 Kbit, DLY 10 usec,

reliability 255/255, txload 1/255, rxload 1/255

Encapsulation ARPA, loopback not set

Keepalive not supported

Half Duplex, 1000Mbps, link type is auto, media type is Auto Select

output flow-control is on, input flow-control is on

ARP type: ARPA, ARP Timeout 04:00:00,

Last input 00:00:08, output 00:00:05, output hang never

Last clearing of \"show interface\" counters never

Input queue: 0/375/0 (size/max/drops); Total output drops: 0

Queueing strategy: fifo

Output queue :0/40 (size/max)

5 minute input rate 0 bits/sec, 0 packets/sec

5 minute output rate 0 bits/sec, 0 packets/sec

0 packets input, 0 bytes, 0 no buffer

Received 0 broadcasts (0 IP multicasts)

0 runts, 0 giants, 0 throttles

0 input errors, 0 CRC, 0 frame, 0 overrun, 0 ignored

0 watchdog, 1017 multicast, 0 pause input

0 input packets with dribble condition detected

#strong[Router1\#show sessions]

% No connections open

#strong[Router1\#show terminal]

Line 0, Location: , Type:

Length: 24 lines, Width: 80 columns

Baud rate (TX/RX) is 9600/9600, no parity, 1 stopbits, 8 databits

Status: PSI Enabled, Ready, Active, Automore On

Capabilities: none

Modem state: Ready

Modem hardware state: CTS\* noDSR DTR RTS

Special Chars: Escape Hold Stop Start Disconnect Activation

^^x none - - none

Timeouts: Idle EXEC Idle Session Modem Answer Session Dispatch

00:10:00 never none not set

Idle Session Disconnect Warning

never

Login-sequence User Response

00:00:30

Autoselect Initial Wait

not set

Modem type is unknown.

Session limit is not set.

Time since activation: 00:03:04

Editing is enabled.

History is enabled, history size is 10.

#strong[Router1\#show users]

Line User Host(s) Idle Location

\* 0 con 0 idle 00:00:00

Interface User Mode Idle Peer Address

#strong[Router1\#show controllers]

#strong[Router1\#show protocols]

Global values:

Internet Protocol routing is enabled

Router1\#

#strong[\3. Конфигурация интерфейсов]

#strong[Настройка интерфейса Router1]

#strong[Router1\#conf t]

Enter configuration commands, one per line. End with CNTL/Z.

#strong[Router1(config)\#int GigabitEthernet0/0/0]

#strong[Router1(config-if)\#no shut]

#strong[Router1(config-if)\#description Ethernet interface on Router 1]

#strong[Настройка интерфейса второго роутера]

#strong[Router\>en]

#strong[Router\#conf t]

Enter configuration commands, one per line. End with CNTL/Z.

Router(config)\#hostname Router2

#strong[Router2(config)\#int GigabitEthernet0/0]

#strong[Router2(config-if)\#no shut]

#strong[Проверка на DTE и DCE]

Команда show controllers для~FastEthernet~интерфейсов не отображает
информацию о DTE/DCE. Она актуальна только для~последовательных (Serial)
интерфейсов.

#strong[Вывод]

В ходе работы были изучены различные IOS команды для взаимодействия с
сетевым интерфейсом.
