#include "DHT.h"
#include <EEPROM.h>
#include <HardwareSerial.h>
#include <DFRobotDFPlayerMini.h>

#define DHTPIN 27       
#define DHTTYPE DHT22
DHT dht(DHTPIN, DHTTYPE);

// Nút nhấn
const int buttonPins[] = {4, 5, 18, 19, 21, 22, 23, 25};
const int numButtons = sizeof(buttonPins) / sizeof(buttonPins[0]);
int buttonState[numButtons] = {0};      // Trạng thái toggle hiện tại (0 hoặc 1)
int lastButtonRead[numButtons] = {0};   // Trạng thái đọc trực tiếp từ pin
int lastStableState[numButtons] = {0};  // Trạng thái ổn định trước đó (để phát hiện cạnh lên)

// Biến trở
const int potPins[] = {32, 33, 34};
const int numPots = sizeof(potPins) / sizeof(potPins[0]);
float potValue[numPots];

// EEPROM
#define ADDR_TEMP_THRESHOLD 0
#define ADDR_FUEL_THRESHOLD 1
#define ADDR_THEME 2     // 0 = light, 1 = dark
#define ADDR_LANG 3      // 0 = en, 1 = vi

int tempThreshold = 30;  // temp default
int fuelThreshold = 20;  // fuel default
int themeMode = 1;    // default dark
int languageMode = 0; // default en
// DFPlayer
HardwareSerial mySerial(2);  // UART2
DFRobotDFPlayerMini myDFPlayer;

void sendThemeLangToQt() {
  Serial.print("theme:");
  Serial.println(themeMode == 1 ? "dark" : "light");

  Serial.print("lang:");
  Serial.println(languageMode == 0 ? "en" : "vi");
}

void setup() {
  Serial.begin(115200);
  dht.begin();
  delay(1000);
  for (int i = 0; i < numButtons; i++) {
    pinMode(buttonPins[i], INPUT_PULLDOWN);
  }

  // ---- EEPROM ----
  EEPROM.begin(64);
  int storedTemp = EEPROM.read(ADDR_TEMP_THRESHOLD);
  if (storedTemp >= 5 && storedTemp <= 60) tempThreshold = storedTemp;

  int storedFuel = EEPROM.read(ADDR_FUEL_THRESHOLD);
  if (storedFuel >= 5 && storedFuel <= 100) fuelThreshold = storedFuel;

  themeMode    = EEPROM.read(ADDR_THEME);   // 0|1
  languageMode = EEPROM.read(ADDR_LANG);    // 0|1
  sendThemeLangToQt();

  Serial.println("ESP32 Ready!");
  // Gửi lại setting cho Qt

  Serial.print("Temp threshold: ");
  Serial.println(tempThreshold);

  Serial.print("Fuel threshold: ");
  Serial.println(fuelThreshold);

    // ---- DFPlayer Setup ----
  mySerial.begin(9600, SERIAL_8N1, 16, 17); 
  delay(1000);

  if (!myDFPlayer.begin(mySerial)) {
    Serial.println("DFPlayer error!");
  } else {
    Serial.println("DFPlayer OK");
    myDFPlayer.volume(25);
  }
}

void loop() {
    // ---- NHẬN LỆNH TỪ QT (chọn bài hoặc chỉnh volume) ----
    if (Serial.available()) {
        String cmd = Serial.readStringUntil('\n');
        cmd.trim();
        
        if (cmd == "get_settings") {
            sendThemeLangToQt();
            return;
        }
        // ---- Theme ----
          if (cmd.startsWith("theme:")) {
            String mode = cmd.substring(6);
            themeMode = (mode == "dark") ? 1 : 0;
            EEPROM.write(ADDR_THEME, themeMode);
            EEPROM.commit();
            sendThemeLangToQt(); // send qt
        } 
        else if (cmd.startsWith("lang:")) {
            String lang = cmd.substring(5);
            languageMode = (lang == "vi") ? 1 : 0;
            EEPROM.write(ADDR_LANG, languageMode);
            EEPROM.commit();
            sendThemeLangToQt(); // send qt
        }
        // --------- LỆNH CHỈNH VOLUME ---------
        if (cmd.startsWith("vol:")) {           
            int vol = cmd.substring(4).toInt();
            if (vol >= 0 && vol <= 30) {
                myDFPlayer.volume(vol);
                Serial.print("Set volume: ");
                Serial.println(vol);
            }
            return;
        }
        if (cmd == "pause") {
            myDFPlayer.pause();
            Serial.println("Music paused");
        } else if (cmd == "start") {
            myDFPlayer.start(); 
            Serial.println("Music resumed");
        }


        // --------- LỆNH CHỌN NHẠC ---------
        if (cmd.endsWith(".mp3")) {
            cmd.replace(".mp3", "");
        }

        int songNum = cmd.toInt();
        if (songNum > 0) {
            Serial.print("Play song: ");
            Serial.println(songNum);
            myDFPlayer.play(songNum);
        }
    }

  // DHT22
  float temp = dht.readTemperature();
  float humid = dht.readHumidity();
  if (isnan(temp)) temp = 0;
  if (isnan(humid)) humid = 0;

  // Xử lý nút nhấn với logic toggle
  for (int i = 0; i < numButtons; i++) {
    int currentRead = digitalRead(buttonPins[i]);
    
    // Phát hiện cạnh lên (rising edge): từ 0 lên 1
    if (currentRead == HIGH && lastStableState[i] == LOW) {
      // Toggle trạng thái
      buttonState[i] = !buttonState[i];
    }
    
    // Cập nhật trạng thái ổn định
    lastStableState[i] = currentRead;
  }

  // Biến trở scale
  potValue[0] = analogRead(potPins[0]) * 160.0 / 4095.0; // 0–160
  potValue[1] = analogRead(potPins[1]) * 8.0 / 4095.0;   // 0–8
  potValue[2] = analogRead(potPins[2]) * 100.0 / 4095.0; // 0–100

   // ---- Logic based on EEPROM thresholds ----
  int tempState = (temp > tempThreshold) ? 1 : 0;
  int fuelState = (potValue[2] < fuelThreshold) ? 1 : 0;

  // Gửi dữ liệu đóng khung qua UART0
  Serial.print(temp, 1); Serial.print("|");
  Serial.print(humid, 1); Serial.print("|");
  Serial.print(potValue[0], 1); Serial.print("|");
  Serial.print(potValue[1], 1); Serial.print("|");
  Serial.print(potValue[2], 1); Serial.print("|");
  for (int i = 0; i < numButtons; i++) {
    Serial.print(buttonState[i]);
     Serial.print("|");
  }
  
  Serial.print(tempState); Serial.print("|");
  Serial.print(fuelState);
  Serial.println();
  
  delay(100); 
}
