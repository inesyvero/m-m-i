
// Código creaco por Verónica Carreño e Inés de Castro para proyecto "movimiento-música-imágen (m-m-i)"
// de la asignatura DIDÁCTICA DE LA INFORMÁTICA Y LA TECNOLOGÍA II. Curso 2019-2020.
// Máster Universitario en Formación del Profesorado de ESO y Bachillerato, FP y Enseñanzas de Idiomas.
// Bajo Licencia CC-BY-SA
<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.


// Fijamos la frecuencia mínima y máxima a emitir, lo que será el rango de nuestro instrumento. Sólo se emplea si usamos el buzzer. 
// En este proyecto finalmente no se emplea pero dejamos las líneas comentadas para facilitar la modularidad en el desarrollo del proyecto.
#define frec_min  131 //#define NOTE_C3 DO 131
#define frec_max  1976 //#define NOTE_B6 SI  1976

// PRIMER SENSOR con el que marcaremos la FRECUENCIA del sonido a emitir.
#define EchoPinFREC  5
#define TriggerPinFREC  6

// SEGUNDO SENSOR con el que marcaremos el VOLUMEN del sonido a emitir.
#define EchoPinVOL  9
#define TriggerPinVOL  10

// Fijamos las distancias mínimas y máximas que nuestros sensores detectan con una fiabilidad aceptable (5-55 cm).
#define cm_minFREC  5
#define cm_maxFREC 56 //dejamos margen a 56 para que cuando la distancia sea >=56 se quede en silencio y podamos usar el valor 55 para emitir
#define cm_minVOL  5
#define cm_maxVOL  56 //dejamos margen a 56 para que cuando >=56 se quede en silencio y podamos usar el valor 55 para emitir

// Definimos dos vectores para recoger los datos de los sensores en 5 muestras y hacer un promedio con lo que
// tratar de mitigar el efecto de "falsas" mediciones" 
int vectorFREC[5];
int vectorVOL[5];
int cont = 0;

// La FUNCIÓN PING detecta , en cm, a cuanta distancia del sensor tenemos un objeto. 
// El valor devuelto, "distanceCm" será la distancia en cm desde nuestras manos al objeto.
// En nuestro proyecto, realmente no nos hace falta tener distancia en cm, con tener cualquier entrada variable con la distancia nos valdría...
// pues luego esto lo vamos a convertir en una frecuencia de sonido que pasarle al buzzer o a Processing
// nos da lo mismo traducir cm --> frec sonido salida , que tiempo entre pulsos (lo que detecta el ultrasonidos) --> frec sonido salida.
// Aún así, hemos decidido sí traducir a cm pues facilita la comprensión del proyecto.

int ping(int TriggerPin, int EchoPin) {
   long duration, distanceCm;
   
   digitalWrite(TriggerPin, LOW);  //para generar un pulso limpio ponemos a LOW 4us
   delayMicroseconds(4);
   digitalWrite(TriggerPin, HIGH);  //generamos Trigger (disparo) de 10us
   delayMicroseconds(10);
   digitalWrite(TriggerPin, LOW);
   duration = pulseIn(EchoPin, HIGH);  //medimos el tiempo entre pulsos, en microsegundos µs
   
// El sensor se basa simplemente en medir el tiempo entre el envío y la recepción de un pulso sonoro.
// Sabemos que la velocidad del sonido es 343 m/s en condiciones de temperatura 20 ºC, 50% de humedad, presión atmosférica a nivel del mar.
// Transformando unidades resulta   343m/s *100cm/m *1s/1000000µs=1cm/29,2µs
   distanceCm = duration * 10 / 292/ 2;   //convertimos a distancia, en cm
   return distanceCm;
}

// Inicializamos comunicación serie y modos de pines:
void setup() {
// Inicializamos la comunicación serie a 9600 baudios
   Serial.begin(9600);
   
// Inicializamos los modos de los pines
   pinMode(TriggerPinFREC, OUTPUT);
   pinMode(EchoPinFREC, INPUT_PULLUP);
   pinMode(TriggerPinVOL, OUTPUT);
   pinMode(EchoPinVOL, INPUT_PULLUP);
}

//Comenzamos a medir la distancia de nuestras manos al instrumento. 
void loop() {

// Llamamos a la FUNCIÓN "ping". Esta función detecta , en cm, a cuanta distancia del sensor tenemos un objeto.
//Hacemos un promedio de 5 mediciones para evitar "falsas" mediciones"  
   
for (cont = 0;cont<5; cont++){
   int cm_FREC = ping(TriggerPinFREC, EchoPinFREC);
   if (cm_FREC>cm_maxFREC) {(cm_FREC=cm_maxFREC);} //ajustamos al máximo de distancia aceptable.
   if (cm_FREC<cm_minFREC) {(cm_FREC=cm_minFREC);} //ajustamos al mínimo de distancia aceptable.
   vectorFREC[cont]=cm_FREC;

   int cm_VOL = ping(TriggerPinVOL, EchoPinVOL);
   if (cm_VOL>cm_maxVOL) {(cm_VOL=cm_maxVOL);} //ajustamos al máximo de distancia aceptable.
   if (cm_VOL<cm_minVOL) {(cm_VOL=cm_minVOL);} //ajustamos al mínimo de distancia aceptable.
   vectorVOL[cont]=cm_VOL; 
 }
cont=0;

int cm_FREC=(vectorFREC[0]+vectorFREC[1]+vectorFREC[2]+vectorFREC[3]+vectorFREC[4])/5;
int cm_VOL=(vectorVOL[0]+vectorVOL[1]+vectorVOL[2]+vectorVOL[3]+vectorVOL[4])/5;
    
// Dejamos comentadas líneas que hemos empleado para depurar.Sólo serán activas las líneas para enviar datos a Processing.
//  Serial.println("------------- DISTANCIA -------------");
//  Serial.print("Lectura de FREC: ");
    Serial.println(cm_FREC); //Envíamos, al puerto serie, el dato de la distancia en cm de nuestra mano al sensor que marca Frecuencia.
//  Serial.println(" cm");
   
//  Serial.print("Lectura de VOL: ");
    Serial.println(cm_VOL);//Envíamos, al puerto serie, el dato de la distancia en cm de nuestra mano al sensor que marca Volumen.
//  Serial.println(" cm");
    
  delay(10); //Dejamos un mínimo delay entre medidas para mejorar la lectura.

}
