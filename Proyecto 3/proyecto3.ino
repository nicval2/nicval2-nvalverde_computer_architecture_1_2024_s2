#include <Servo.h>

// ---------- Pines ----------
#define TRIG_SENSOR1 2
#define ECHO_SENSOR1 3

#define TRIG_SENSOR2 4
#define ECHO_SENSOR2 5

#define SERVO_DISPENSER 6
#define SERVO_STORAGE 7

#define BUZZER 8

// ---------- Objetos ----------
Servo servoDispenser;
Servo servoStorage;

// ---------- Umbrales (en cm) ----------
const int FOOD_LEVEL_THRESHOLD = 15;     // Nivel bajo de comida mascota
const int STORAGE_LEVEL_THRESHOLD = 20;  // Depósito casi vacío

// ---------- Función Ultrasonido ----------
long readUltrasonic(int trigPin, int echoPin) {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH, 30000); // timeout 30 ms
  long distance = duration * 0.034 / 2;
  return distance;
}

void setup() {
  pinMode(TRIG_SENSOR1, OUTPUT);
  pinMode(ECHO_SENSOR1, INPUT);
  pinMode(TRIG_SENSOR2, OUTPUT);
  pinMode(ECHO_SENSOR2, INPUT);

  pinMode(BUZZER, OUTPUT);

  servoDispenser.attach(SERVO_DISPENSER);
  servoStorage.attach(SERVO_STORAGE);

  servoDispenser.write(0);
  servoStorage.write(0);

  Serial.begin(9600);
}

void loop() {
  long foodDistance = readUltrasonic(TRIG_SENSOR1, ECHO_SENSOR1);
  long storageDistance = readUltrasonic(TRIG_SENSOR2, ECHO_SENSOR2);

  Serial.print("Comida mascota: ");
  Serial.print(foodDistance);
  Serial.print(" cm | Almacen: ");
  Serial.print(storageDistance);
  Serial.println(" cm");

  // ---------- Control de comida para la mascota ----------
  if (foodDistance > FOOD_LEVEL_THRESHOLD) {
    Serial.println("Poca comida - Dispensando...");
    servoDispenser.write(90);
    delay(5);                 // abre compuerta
    servoDispenser.write(0);  // cierra
    delay(2000);              // evita múltiples activaciones
  }

  // ---------- Control de comida almacenada ----------
  if (storageDistance > STORAGE_LEVEL_THRESHOLD) {
    Serial.println("Almacen VACIO - ALERTA");
    digitalWrite(BUZZER, HIGH);
    servoStorage.write(90);
  } else {
    digitalWrite(BUZZER, LOW);
    servoStorage.write(0);
  }

  delay(500);
}
