void setup() {
  Serial.begin(115200);
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.println("test");
}

void loop() {
  PrintMillis();
  CheckSerial();
  delay(50);
}

void PrintMillis (void) {
  Serial.println(millis());
}

void CheckSerial() {
  if (Serial.available() > 0) {
    String holder = Serial.readStringUntil('\n');
    holder.trim();
    if (holder == "Test Me") {
      digitalWrite(LED_BUILTIN, HIGH);
      delay(500);
    }
  } else {
    digitalWrite(LED_BUILTIN, LOW);
  }
}
