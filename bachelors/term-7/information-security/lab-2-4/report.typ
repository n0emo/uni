#strong[ФЕДЕРАЛЬНОЕ АГЕНТСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА]

Федеральное государственное бюджетное образовательное учреждение

высшего образования

#strong[«Петербургский государственный университет путей сообщения]

#strong[Императора Александра I»]

#strong[ (ФГБОУ ВО ПГУПС)]

Факультет «Автоматизация и интеллектуальные технологии»

Кафедра «Информатика и информационная безопасность»

Лабораторная работа № 2.4

по дисциплине

«Защита информации»

«Использование криптографических сервис-провайдеров при решении задач
профессиональной деятельности. Электронная подпись»

Санкт-Петербург

2025

#strong[Оценка лабораторной работы]

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    [Показатель

    #strong[ оценивания ]

    ], [Критерии

    оценивания

    ], [Шкала оценивания],
    table.cell(rowspan: 4)[Качество выполнения задания, отчета и защиты
    по лабораторной работе], [Нет замечаний], [],
    [Зафиксирован #emph[один из] следующих недочетов:

    - допущены ошибки при выполнении задания, но в целом задание
      выполнено;
    - даны неверные ответы на часть контрольных вопросов;
    - имеются отдельные недостатки в оформлении отчета;
    - работа сдана с опозданием на две недели и более.

    ], [],
    [Зафиксировано два недочета из перечисленных в предыдущем
    пункте], [],
    [Допущено значительное количество неточностей или задание не
    выполнено, не даны ответы на контрольные вопросы], [],
    table.cell(colspan: 2)[Количество баллов по результатам проверки и
    защиты лабораторной работы (вписывается преподавателем)], [],
  )]
  , kind: table
  )

#strong[1.~Задание]

Дополнить приложение-сервер, разработанное в лабораторной работе № 2.3,
следующими функциональными возможностями:

- формирование электронной подписи (ЭП) к сообщению.

Дополнить приложение-клиент, разработанное в лабораторной работе № 2.3,
следующими функциональными возможностями:

- проверка ЭП сервера.

Проверить работоспособность приложений:

- сгенерировать пару «открытый-закрытый ключ»;
- передать открытый ключ клиентскому приложению;
- сгенерировать симметричные ключи шифрования (генерация производится на
  клиентской стороне; ключи генерируются для использования в
  симметричных шифрах, указанных в варианте задания);
- передать серверу симметричные ключи, зашифрованные с помощью открытого
  ключа по алгоритму RSA;
- на серверной стороне -- расшифровать симметричные ключи, после чего
  зашифровать произвольное сообщение;
- сформировать ЭП к сообщению;
- передать зашифрованные и подписанные данные клиенту;
- на клиентской стороне -- расшифровать полученные данные и проверить
  ЭП.

Если открытые и расшифрованные данные совпадают и проверка ЭП показала,
что подпись действительна, значит, все криптографические функции в
приложениях реализованы правильно.

#strong[\2. Выполнение]

В ходе выполнения лабораторной работы разработано программное
обеспечение для ЭП в дополнение групповому чату из 2.3

Обновлённый принцип работы приложения

+ Клиент вводит сообщение, шифрует AES и отправляет серверу,
+ Сервер получает сообщение, расшифровывает, подписывает Ed25519,
  перешифровывает, отправляет всем клиентам
+ Остальные клиенты получают, расшифровывает, проверяет подпись,
  показывает сообщение

Исходный текст разработанного программного обеспечения выглядит
следующим образом:

server/main.go

package main

import (

\"ciphered-chat/common\"

\"crypto/aes\"

\"crypto/cipher\"

\"crypto/ed25519\"

\"crypto/rand\"

\"crypto/rsa\"

\"crypto/x509\"

\"encoding/pem\"

\"errors\"

\"fmt\"

\"log\"

\"net\"

\"os\"

\"sync\"

)

func main() {

if len(os.Args) \> 1 && (os.Args\[1\] == \"help\" || os.Args\[1\] ==
\"-\-help\" || os.Args\[1\] == \"-h\") {

fmt.Println(\"Usage: \./server \[host\]\")

}

host := \"127.0.0.1:8080\"

if len(os.Args) \> 1 {

host = os.Args\[1\]

}

server, err := NewServer(host)

if err != nil {

log.Fatalf(\"Could not start server: %v\", err)

}

defer server.Close()

log.Printf(\"Listening at %v\\n\", server.Addr())

server.Serve()

}

type Server struct {

mu sync.Mutex

addr string

listener net.Listener

clients map\[string\]Client

signingPrivateKey ed25519.PrivateKey

signingPublicKey ed25519.PublicKey

}

type Client struct {

conn net.Conn

ch chan \[\]byte

aesBlock cipher.Block

}

func NewServer(host string) (\*Server, error) {

tcplistener, err := net.Listen(\"tcp\", host)

if err != nil {

return nil, err

}

salt := make(\[\]byte, 4096)

rand.Read(salt)

edPublicKey, edPrivateKey, err := ed25519.GenerateKey(rand.Reader)

if err != nil {

return nil, err

}

server := &Server{

clients: make(map\[string\]Client),

addr: tcplistener.Addr().String(),

listener: tcplistener,

signingPrivateKey: edPrivateKey,

signingPublicKey: edPublicKey,

}

return server, nil

}

func (s \*Server) Close() {

s.listener.Close()

}

func (s \*Server) Addr() string {

return s.addr

}

func (s \*Server) Serve() {

for {

conn, err := s.listener.Accept()

if err != nil {

log.Printf(\"Could not accept connection: %v\", err)

continue

}

go s.handleConnection(conn)

}

}

func (s \*Server) handleConnection(conn net.Conn) {

defer func() {

conn.Close()

log.Printf(\"%v disconnected\\n\", conn.RemoteAddr())

}()

client, err := s.performHandshake(conn)

if err != nil {

log.Printf(\"Error performing handshake with %v: %v\",
conn.RemoteAddr(), err)

return

}

addr := client.conn.RemoteAddr().String()

log.Printf(\"%v connected\\n\", addr)

s.mu.Lock()

s.clients\[addr\] = client

s.mu.Unlock()

cSocket := make(chan \[\]byte)

cClose := make(chan bool)

defer func() {

s.mu.Lock()

delete(s.clients, addr)

s.mu.Unlock()

}()

go client.receiveMessages(cSocket, cClose)

for {

select {

case msg := \<-cSocket:

s.mu.Lock()

for key, cli := range s.clients {

if key != addr {

cli.ch \<- msg

}

}

s.mu.Unlock()

case msg := \<-client.ch:

sig := ed25519.Sign(s.signingPrivateKey, msg)

streamCipher := cipher.NewCTR(client.aesBlock, common.IV)

streamCipher.XORKeyStream(msg, msg)

err = common.WriteMessage(client.conn, msg)

if err != nil {

log.Printf(\"Could not write to %v: %v\", addr, err)

return

}

err = common.WriteMessage(client.conn, sig)

if err != nil {

log.Printf(\"Could not write to %v: %v\", addr, err)

return

}

case \_ = \<-cClose:

return

}

}

}

func (s \*Server) performHandshake(conn net.Conn) (Client, error) {

privateKey, \_ := rsa.GenerateKey(rand.Reader, common.RsaKeySize)

privateKeyBytes := x509.MarshalPKCS1PublicKey(&privateKey.PublicKey)

keyBlock := pem.Block{

Type: \"RSA PUBLIC KEY\",

Bytes: privateKeyBytes,

}

keyBytes := pem.EncodeToMemory(&keyBlock)

\_, err := conn.Write(keyBytes)

if err != nil {

return Client{}, err

}

var encryptedSymmetricKey \[512\]byte

n, err := conn.Read(encryptedSymmetricKey\[:\])

if err != nil {

return Client{}, err

}

if n == 0 {

return Client{}, errors.New(\"unexpected EOF\")

}

symmetricKey, err := rsa.DecryptOAEP(common.RsaHash, nil, privateKey,
encryptedSymmetricKey\[:\], common.SymmetricKeyLabel)

if err != nil {

return Client{}, err

}

aesBlock, err := aes.NewCipher(symmetricKey\[:\])

if err != nil {

return Client{}, err

}

n, err = conn.Write(s.signingPublicKey)

if err != nil {

return Client{}, err

}

if n != ed25519.PublicKeySize {

return Client{}, errors.New(\"Could not send public signing key\")

}

client := Client{

conn: conn,

ch: make(chan \[\]byte),

aesBlock: aesBlock,

}

return client, nil

}

func (client \*Client) receiveMessages(cSocket chan \[\]byte, cClose
chan bool) {

for {

msg, err := common.ReadMessage(client.conn)

if err != nil {

log.Printf(\"Error receiving message from %v: %v\\n\",
client.conn.RemoteAddr(), err)

cClose \<- false

}

streamCipher := cipher.NewCTR(client.aesBlock, common.IV)

streamCipher.XORKeyStream(msg, msg)

cSocket \<- msg

}

}

client/main.go

package main

import (

\"bufio\"

\"crypto/aes\"

\"crypto/cipher\"

\"crypto/ed25519\"

\"crypto/rand\"

\"crypto/rsa\"

\"crypto/x509\"

\"encoding/binary\"

\"encoding/pem\"

\"errors\"

\"fmt\"

\"log\"

\"net\"

\"os\"

\"ciphered-chat/common\"

)

type State struct {

conn net.Conn

aesBlock cipher.Block

signingKey ed25519.PublicKey

}

func main() {

if len(os.Args) \> 1 && (os.Args\[1\] == \"help\" || os.Args\[1\] ==
\"-\-help\" || os.Args\[1\] == \"-h\") {

fmt.Println(\"Usage: \./server \<host\>\")

}

if len(os.Args) != 2 {

fmt.Println(\"Usage: \./server \<host\>\")

os.Exit(64)

}

host := os.Args\[1\]

conn, err := net.Dial(\"tcp\", host)

if err != nil {

fmt.Printf(\"Could not connect to server: %v\\n\", err)

os.Exit(1)

}

defer conn.Close()

fmt.Printf(\"Established connection to %v\\n\", conn.RemoteAddr())

state, err := performHandshake(conn)

if err != nil {

log.Fatalf(\"Error performing handshake with server: %v\\n\", err)

}

fmt.Println(\"Performed handshake with server\")

cReadline := make(chan string)

cReceive := make(chan \[\]byte)

cClose := make(chan string)

go handleConn(&state, cReceive, cClose)

go handleConsole(cReadline, cClose)

for {

select {

case toSend := \<-cReadline:

msg := \[\]byte(toSend)

streamCipher := cipher.NewCTR(state.aesBlock, common.IV)

streamCipher.XORKeyStream(msg, msg)

common.WriteMessage(conn, msg)

case msg := \<-cReceive:

fmt.Print(string(msg))

case closeMsg := \<-cClose:

fmt.Println(closeMsg)

os.Exit(0)

}

}

}

func handleConn(state \*State, ch chan \[\]byte, cClose chan string) {

for {

msg, err := common.ReadMessage(state.conn)

if err != nil {

cClose \<- err.Error()

return

}

streamCipher := cipher.NewCTR(state.aesBlock, common.IV)

streamCipher.XORKeyStream(msg, msg)

sig, err := common.ReadMessage(state.conn)

if err != nil {

cClose \<- err.Error()

return

}

if !ed25519.Verify(state.signingKey, msg, sig) {

cClose \<- \"Invalid digital signature\"

return

}

ch \<- msg

}

}

func handleConsole(ch chan string, cClose chan string) {

reader := bufio.NewReader(os.Stdin)

for {

text, err := reader.ReadString(\'\\n\')

if err != nil {

cClose \<- \"Could not read from stdin\"

}

ch \<- text

}

}

func performHandshake(conn net.Conn) (s State, error error) {

buf := make(\[\]byte, 1024)

n, err := conn.Read(buf)

if err != nil {

return State{}, err

}

if n == 0 {

return State{}, errors.New(\"Could not perform handshake: unexpected
EOF\")

}

keyBlock, \_ := pem.Decode(buf)

if keyBlock == nil {

return State{}, errors.New(\"Could not perform handshake: error parsing
public key block\")

}

publicKey, err := x509.ParsePKCS1PublicKey(keyBlock.Bytes)

if err != nil {

return State{}, err

}

var symmetricKey \[32\]byte

rand.Read(symmetricKey\[:\])

encryptedKey, err := rsa.EncryptOAEP(common.RsaHash, rand.Reader,
publicKey, symmetricKey\[:\], common.SymmetricKeyLabel)

if err != nil {

return State{}, err

}

err = binary.Write(conn, common.ByteOrder, encryptedKey)

if err != nil {

return State{}, err

}

aesBlock, err := aes.NewCipher(symmetricKey\[:\])

if err != nil {

log.Fatalf(\"Could not create cipher: %v\\n\", err)

}

signingKeyBuf := make(\[\]byte, ed25519.PublicKeySize)

n, err = conn.Read(signingKeyBuf)

if err != nil {

return State{}, nil

}

if n != ed25519.PublicKeySize {

return State{}, errors.New(\"Coul not get public signing key\")

}

state := State{

conn: conn,

aesBlock: aesBlock,

signingKey: signingKeyBuf,

}

return state, nil

}

common/lib.go

package common

import (

\"encoding/binary\"

\"errors\"

\"hash/adler32\"

\"io\"

)

var IV = \[\]byte(\"J55NceZ0ST1sNfQ5\")

var ByteOrder = binary.LittleEndian

var RsaHash = adler32.New()

const RsaKeySize = 4096

var SymmetricKeyLabel = \[\]byte(\"symmetric key\")

type Header struct {

Len uint32

}

func WriteMessage(writer io.Writer, msg \[\]byte) error {

header := Header{Len: uint32(len(msg))}

err := binary.Write(writer, ByteOrder, header)

if err != nil {

return err

}

totalWritten := 0

for {

n, err := writer.Write(msg\[totalWritten:\])

if err != nil {

return err

}

if n == 0 {

return errors.New(\"EOF\")

}

totalWritten += n

if totalWritten \>= n {

break

}

}

return nil

}

func ReadMessage(reader io.Reader) (\[\]byte, error) {

header := Header{}

err := binary.Read(reader, ByteOrder, &header)

if err != nil {

return nil, err

}

buf := make(\[\]byte, header.Len)

totalRead := 0

for {

n, err := reader.Read(buf\[totalRead:\])

if err != nil {

return nil, err

}

if n == 0 {

return nil, errors.New(\"EOF\")

}

totalRead += n

if totalRead \>= int(header.Len) {

break

}

}

return buf, nil

}

Результат тестирования разработанного программного обеспечения:

Сервер с подключенными клиентами#strong[]

#box(image("./assets/image-1.png", height: 53.25mm, width: 165.01mm))

Отправка сообщения от клиента 1#strong[]

#box(image("./assets/image-2.png", height: 53.15mm, width: 165.01mm))

Отображение у Клиента 2#strong[]

#box(image("./assets/image-3.png", height: 57.45mm, width: 165.01mm))

Вывод#strong[]

В ходе выполнения лабораторной работы было успешно модифицировано
сетевое приложение (защищенный групповой чат), разработанное в
лабораторной работе 2.3, путем добавления функциональности электронной
подписи (ЭП) на основе алгоритма Ed25519.
