== 4.1 Определение схем сообщений

В проекте определён пакет deanery-schemas, который содержит в себе различные
модули со структурами, определяющими HTTP-схемы и WebSocket-сообщения.
derive-макросы "Serialize" и "Deserialize" из пакета serde позволяют
сгенерировать код для сериализации и десериализации объекта в любой формат,
поддерживаемый serde, например: JSON, XML, TOML, YAML. @device-message
показывает объявление типа сообщения для устройства отображения.

#figure(
  ```rs
  #[derive(Debug, Serialize, Deserialize, ToSchema)]
  pub enum InfotabDeviceMessage {
      DisplaySchedule {
          room: String,
          schedule: ClassroomSchedule,
      },

      // Others...
  }
  ```,
  kind: image,
  caption: [Объявление перечисления InfotabDeviceMessage]
) <device-message>

Полное определение типов вынесено в приложение @sup-schemas

== 4.2 Обработка устройств на стороне сервера

Устройства подключаются к HTTP-точке /ws/infotab/{id} сервера. Функция-обработчик
показана на рисунке #ref(label("ws-handler-func"), supplement: none). ID
устройства имеет формат UUID и передаётся в пути запроса.

#figure(
  ```rs
  pub async fn handler(
      State(device_service): State<BoxedInfotabDeviceBackendService>,
      State(schedule_service): State<BoxedScheduleService>,
      Path(InfotabDeviceParams { id }): Path<InfotabDeviceParams>,
      ws: WebSocketUpgrade,
      ConnectInfo(addr): ConnectInfo<SocketAddr>,
  ) -> impl IntoResponse {
      let id = InfotabDeviceId::new(id);
      info!("Got ws upgrade request from address {addr}, id {id}");
      ws.on_upgrade(move |ws| handle_socket(ws, id, device_service, schedule_service))
  }
  ```,
  kind: image,
  caption: [Обработчик подключений /ws/infotab]
) <ws-handler-func>

ID устройства генерируется самим устройством на основе его аппаратных
характеристик. Например, устройства с ОС Android используют
Settings.Secure.ANDROID_ID. Подробнее об этом описано в следующем разделе.

При поступлении HTTP-запроса сервер выполняет шаги по алгоритму:
+ *Получение подключения*: Принять WebSocket upgrade запрос с ID устройства.
+ *Проверка/сохранение*: Проверить существование устройства в БД, если нет --
  создать новую запись.
+ *Создание канала*: Создать неограниченный канал для команд устройству.
+ *Отправка расписания*: Если у устройства назначена аудитория -- загрузить и
  отправить текущее расписание из БД.
+ *Регистрация в сервисе*: Зарегистрировать устройство в device_service с его
  каналом.
+ *Основной цикл*: Параллельно обрабатывать:
   - входящие WS-сообщения от устройства (Close, Pong);
   - исходящие команды из канала (Ping, DisplaySchedule).
+ *Отключение*: При завершении — отправить закрывающий фрейм, отключить устройство
  от сервиса.

Все информационные сообщения отправляются в виде текстовых сообщений WebSocket.
Полезная нагрузка сериализуется в формат JSON.

== 4.3 Получение и обработка данных отображения на стороне клиента

Для подключения к серверу требуется уникальный ID устройства. В клиенте
устройств отображения он определяется при запуске приложения. Устройство
генерирует UUID 5 версии на основе строки из конфигурации ОС:
- *Linux*: содержимое файла /etc/machine-id.
- *MacOS*: IOPlatformExpertDevice.IOPlatformUUID из вывода команды ioreg.
- *Android*: значение Settings.Secure.ANDROID_ID.
- *WebAssembly*: значение поля id из строки поиска URL.

После определения ID запускается приложение на базе egui, выполняющее отрисовку
интерфейса устройства отображения. Подключение к серверу и получение сообщений
выполняется в асинхронном режиме. На рисунке
#ref(label("fn-process-events"), supplement: none) можно видеть определение
метода process_events, который обрабатывает события из структуры типа
DataSource и изменяет поле data структуры приложения, на основании которого
отрисовывается интерфейс.

#figure(
  ```rs
  pub fn process_events(&mut self) {
      self.source.update();
      for msg in self.source.messages() {
          match msg {
              InfotabDeviceMessage::DisplaySchedule { room, schedule } => {
                  let week = match week_parity_now() {
                      WeekParity::Even => schedule.even,
                      WeekParity::Odd => schedule.odd,
                  };
                  let day = week
                      .days
                      .into_iter()
                      .nth(weekday_now().num_days_from_monday() as usize)
                      .expect("Week has exactly 7 days")
                      .into();

                  self.data = BoardAppData::Day { room, day }
              }
          }
      }
  }
  ```,
  kind: image,
  caption: [Метод App::process_events]
) <fn-process-events>

Определение DataSource и логика работы с WebSocket подключением показана в
приложении @sup-data-source. В модуле реализовано автоматическое переподключение
к серверу с нарастающим интервалом.
