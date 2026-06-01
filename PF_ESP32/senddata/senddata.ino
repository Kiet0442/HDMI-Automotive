#include "DHT.h"
#include <EEPROM.h>
#include <HardwareSerial.h>
#include <DFRobotDFPlayerMini.h>

/* ===================== CONFIG ===================== */
#define DHTPIN 27
#define DHTTYPE DHT22
#define EEPROM_SIZE 64

/* ===================== DHT ===================== */
DHT dht(DHTPIN, DHTTYPE);

/* ===================== BUTTON ===================== */
const int buttonPins[] = {4, 5, 18, 19, 21, 22, 23, 25};
const int numButtons = sizeof(buttonPins) / sizeof(buttonPins[0]);

bool buttonState[numButtons] = {0};       // trạng thái toggle
bool lastButtonState[numButtons] = {0};   // trạng thái trước đó

/* ===================== POTENTIOMETER ===================== */
const int potPins[] = {32, 33, 34};
const int numPots = sizeof(potPins) / sizeof(potPins[0]);
float potValue[numPots];

// scale cho từng biến trở
const float potScale[numPots] = {160.0, 8.0, 100.0};

/* ===================== EEPROM ===================== */
#define ADDR_TEMP_THRESHOLD 0
#define ADDR_FUEL_THRESHOLD 1
#define ADDR_THEME 2
#define ADDR_LANG 3

int tempThreshold = 30;
int fuelThreshold = 20;
int themeMode = 1;      // 0=light, 1=dark
int languageMode = 0;   // 0=en, 1=vi

/* ===================== DFPLAYER ===================== */
HardwareSerial mySerial(2);   // UART2
DFRobotDFPlayerMini myDFPlayer;

/* ===================== FUNCTIONS ===================== */

void sendThemeLangToQt() {
  Serial.print("theme:");
  Serial.println(themeMode ? "dark" : "light");

  Serial.print("lang:");
  Serial.println(languageMode ? "vi" : "en");
}

/* ---------- Handle serial command ---------- */
void handleSerialCmd() {
  if (!Serial.available()) return;

  String cmd = Serial.readStringUntil('\n');
  cmd.trim();

  if (cmd == "get_settings") {
    sendThemeLangToQt();
    return;
  }

  if (cmd.startsWith("theme:")) {
    themeMode = cmd.endsWith("dark");
    EEPROM.write(ADDR_THEME, themeMode);
    EEPROM.commit();
    sendThemeLangToQt();
    return;
  }

  if (cmd.startsWith("lang:")) {
    languageMode = cmd.endsWith("vi");
    EEPROM.write(ADDR_LANG, languageMode);
    EEPROM.commit();
    sendThemeLangToQt();
    return;
  }

  if (cmd.startsWith("vol:")) {
    int vol = cmd.substring(4).toInt();
    if (vol >= 0 && vol <= 30) {
      myDFPlayer.volume(vol);
    }
    return;
  }

  if (cmd == "pause") {
    myDFPlayer.pause();
    return;
  }

  if (cmd == "start") {
    myDFPlayer.start();
    return;
  }

  if (cmd.endsWith(".mp3")) {
    cmd.replace(".mp3", "");
  }

  int song = cmd.toInt();
  if (song > 0) {
    myDFPlayer.play(song);
  }
}

/* ---------- Read buttons (toggle) ---------- */
void readButtons() {
  for (int i = 0; i < numButtons; i++) {
    bool current = digitalRead(buttonPins[i]);
    if (current && !lastButtonState[i]) {
      buttonState[i] = !buttonState[i];
    }
    lastButtonState[i] = current;
  }
}

/* ---------- Read potentiometers ---------- */
void readPots() {
  for (int i = 0; i < numPots; i++) {
    potValue[i] = analogRead(potPins[i]) * potScale[i] / 4095.0;
  }
}

/* ---------- Send data to Qt ---------- */
void sendData(float temp, float humid) {
  Serial.print(temp, 1); Serial.print("|");
  Serial.print(humid, 1); Serial.print("|");

  for (int i = 0; i < numPots; i++) {
    Serial.print(potValue[i], 1);
    Serial.print("|");
  }

  for (int i = 0; i < numButtons; i++) {
    Serial.print(buttonState[i]);
    Serial.print("|");
  }

  Serial.print(temp > tempThreshold); Serial.print("|");
  Serial.print(potValue[2] < fuelThreshold);
  Serial.println();
}

/* ===================== SETUP ===================== */
void setup() {
  Serial.begin(115200);
  dht.begin();

  for (int i = 0; i < numButtons; i++) {
    pinMode(buttonPins[i], INPUT_PULLDOWN);
  }

  EEPROM.begin(EEPROM_SIZE);

  int v;
  v = EEPROM.read(ADDR_TEMP_THRESHOLD);
  if (v >= 5 && v <= 60) tempThreshold = v;

  v = EEPROM.read(ADDR_FUEL_THRESHOLD);
  if (v >= 5 && v <= 100) fuelThreshold = v;

  themeMode    = EEPROM.read(ADDR_THEME);
  languageMode = EEPROM.read(ADDR_LANG);

  sendThemeLangToQt();

  mySerial.begin(9600, SERIAL_8N1, 16, 17);
  delay(1000);

  if (myDFPlayer.begin(mySerial)) {
    myDFPlayer.volume(25);
  }

  Serial.println("ESP32 READY");
}

/* ===================== LOOP ===================== */
void loop() {
  handleSerialCmd();

  float temp = dht.readTemperature();
  float humid = dht.readHumidity();
  if (isnan(temp)) temp = 0;
  if (isnan(humid)) humid = 0;

  readButtons();
  readPots();
  sendData(temp, humid);

  delay(100);
}
