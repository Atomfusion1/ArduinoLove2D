Love2d Version: 11.4
Why is this Threaded? Because io.read("*line") is blocking and does not have a timeout so if the arduino does not send data then Love2d Locks
Why is Send Threaded? Because io becomes locked to the thread and you can not switch io from thread to the main 

Overall I would not trust this for production .. but its a fun project 
Lua does not handle Serial Well, and I have not found an easy to use library for Love2d 10/22 


Enter to Send Data 
Data is received . Do not Send data from arduino faster then delayMicroseconds(500)


Arduino Uno or Mega 

void setup() {
    Serial.begin(115200);
    pinMode(LED_BUILTIN, OUTPUT);
    Serial.println("test");
  }
  
  void loop() {
    PrintMillis();
    CheckSerial();
    delay(10);
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