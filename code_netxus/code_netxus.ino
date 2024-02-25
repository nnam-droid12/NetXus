#include <Arduino.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <LiquidCrystal.h>
#include <Keypad.h>

#define FIREBASE_HOST "arduino-test-324dd-default-rtdb.firebaseio.com" // Replace with your Firebase project URL
#define FIREBASE_AUTH "AIzaSyC_WxgQSBu_FoU9s6xnHI2fpIBMcbm4NGA" // Replace with your Firebase authentication token
#define WIFI_SSID "Techgik"
#define WIFI_PASSWORD "delightgik@2024"

LiquidCrystal lcd(12, 11, 5, 4, 3, 2); // Adjust pin numbers based on your LCD connection

const byte ROWS = 4; // Four rows
const byte COLS = 3; // Three columns
char keys[ROWS][COLS] = {
  {'1','2','3'},
  {'4','5','6'},
  {'7','8','9'},
  {'*','0','#'}
};
byte rowPins[ROWS] = {9, 8, 7, 6}; // Connect keypad ROW0, ROW1, ROW2 and ROW3 to these Arduino pins.
byte colPins[COLS] = {13, 10, A0}; // Connect keypad COL0, COL1 and COL2 to these Arduino pins.

Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );

FirebaseData fbdo;

void setup() {
  Serial.begin(115200);
  lcd.begin(16, 2); // Initialize the LCD with 16 columns and 2 rows
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("WiFi connected");

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);

  // Sign up if not already signed up
  if (!Firebase.signUp(&fbdo)) {
    Serial.println("Sign up failed.");
    Serial.println(fbdo.errorReason());
  } else {
    Serial.println("Sign up successful.");
  }
}

void loop() {
  // Display welcome message and ask for password
  lcd.clear();
  lcd.print("Welcome");
  lcd.setCursor(0, 1);
  lcd.print("Enter Password:");

  // Wait for the password input
  String password = "";
  while (password.length() < 4) {
    char key = keypad.getKey();
    if (key != NO_KEY && key != '#') {
      password += key;
      lcd.print('*'); // Print '*' for each entered digit
      delay(200);
    }
  }

  // Wait for the user to press the enter key
  while (keypad.getKey() != '#') {
    // Wait until the enter key is pressed
  }

  // Display message for selecting device type
  lcd.clear();
  lcd.print("Are you charging");
  lcd.setCursor(0, 1);
  lcd.print("phone or laptop?");
  lcd.setCursor(0, 2);
  lcd.print("Press 1 for laptop");
  lcd.setCursor(0, 3);
  lcd.print("Press 0 for phone");

  // Wait for the device type input
  char deviceType = ' ';
  while (deviceType != '0' && deviceType != '1') {
    deviceType = keypad.getKey();
  }

  // Send data to Firebase
  if (Firebase.ready()) {
    // Read analog input (assuming a 12-bit ADC)
    float voltage = (float)analogRead(A1) / 4096 * 24 * 47000 / 92931;

    // Convert voltage to percentage
    float percentage = (voltage / 12.6) * 100;

    // Display the result on the LCD
    lcd.clear();
    if (deviceType == '0') {
      lcd.print("Phone Charging");
    } else if (deviceType == '1') {
      lcd.print("Laptop Charging");
    } else if (deviceType == '*' || deviceType == '#') {
      lcd.print("Laptop & Phone Charging");
    }
    lcd.setCursor(0, 1);
    lcd.print("Battery: ");
    lcd.print(percentage);
    lcd.print("%");

    // Set data at the specified database path
    if (Firebase.RTDB.setFloat(&fbdo, "voltage", voltage)) {
      Serial.println("Voltage Data Sent Successfully");
    } else {
      Serial.println("Failed to Send Voltage Data");
      Serial.println("Reason: " + fbdo.errorReason());
    }

    if (Firebase.RTDB.setFloat(&fbdo, "battery_percentage", percentage)) {
      Serial.println("Percentage Data Sent Successfully");
    } else {
      Serial.println("Failed to Send Percentage Data");
      Serial.println("Reason: " + fbdo.errorReason());
    }

    if (Firebase.RTDB.setString(&fbdo, "deviceType", String(deviceType))) {
      Serial.println("Device Type Data Sent Successfully");
    } else {
      Serial.println("Failed to Send Device Type Data");
      Serial.println("Reason: " + fbdo.errorReason());
    }
  }

  // Delay for a while
  delay(200);
}

void drawPercentageBar(float percentage) {
  int barLength = map(percentage, 0, 100, 0, 16);

  lcd.setCursor(0, 2);
  lcd.print("[");
  for (int i = 0; i < barLength; i++) {
    lcd.print("=");
  }
  for (int i = barLength; i < 16; i++) {
    lcd.print(" ");
  }
  lcd.print("]");
}