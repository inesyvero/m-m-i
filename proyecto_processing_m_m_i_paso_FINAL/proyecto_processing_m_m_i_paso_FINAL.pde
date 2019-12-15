
// Código creado por Verónica Carreño e Inés de Castro para proyecto "movimiento-música-imágen (m-m-i)"
// de la asignatura DIDÁCTICA DE LA INFORMÁTICA Y LA TECNOLOGÍA II. Curso 2019-2020.
// Máster Universitario en Formación del Profesorado de ESO y Bachillerato, FP y Enseñanzas de Idiomas.
// Bajo Licencia Creative Commons Attribution-ShareAlike 4.0 International License

import processing.serial.*;
import processing.sound.*;

//El espectro de nuestro instrumento será de 3 escalas
// Fijamos la frecuencia mínima y máxima a emitir, 
int frec_min_nota=131; //NOTE_C3 DO 131
int frec_max_nota=1976; //NOTE_B6 SI  1976

// Creamos el objeto de Serial class. Dato que leeremos del puerto serie, en este caso de lo que Arduino envíe
Serial myPort; 

// Creamos el objeto de clase TriOsc. Hará que se emita un oscilador generando una onda tipo Triangular.
// Finalmente no lo usaremos en el projecto
// TriOsc triangle;//Creamos objeto de TriOsc class
// Creamos el objeto de clase SinOsc. Hará que se emita un oscilador generando una onda Sinusoidal
SinOsc sin_sound; //Creamos objeto de SinOsc class

// Definimos las variables que leeremos del puerto serie
String cm_FREC = null;
String cm_VOL = null;
String myString = null;

// Definimos las variables para el manejo de los datos tipo String envíados por el Arduino al puerto serie
// haciendo la traducción de String --> int --> float (a float para la función map () a emplear despues).
int int_cm_FREC ;
int int_cm_VOL ;
float float_cm_FREC ;
float float_cm_VOL ;
float frec_nota ;
float vol_nota ;

// Definimos las variables con las que marcaremos el color y la saturación
float stroke_color ;
float stroke_sat ;

int despl_x ;
int despl_y ;

// Definimos el caracter ASCII linefeed. Importante para entender los datos que leemos del puerto serie correctamente, 
// pues, desde Arduino estamos enviando los datos de cada sensor separados por un "linefed" o Salto de línea
int lf = 10;      

//Datatype for storing images
PImage img;


void setup() {
  
// Definimos los parámetros generales del lienzo.
      noStroke();   
      size(1400, 600);
      textSize(25);
      frameRate(10); //Especifiacamos el número de frames por segundo a mostrar. El valor por defecto es de 60
      
// Configuramos la comunicación serie.
      String portName = Serial.list()[0];
      myPort = new Serial(this, portName, 9600);
      myPort.clear();  
      // Throw out the first reading, in case we started reading in the middle of a string from the sender.
      myString = myPort.readStringUntil(lf);
      myString = null;
      
// myPort.bufferUntil(lf); //No tenemos clara la necesida o uso de este código,
// lo probamos en un momento en el que nos daba problemas la comunicación serie. Pero lo solucionamos evaluándo que el Arduino no estuviera enviando nulos.
    

// Instanciamos el objeto sin_sound de la clase SinOsc
      sin_sound = new SinOsc(this); 
// Inicializamos las variables que nos intresan 
      int_cm_FREC=0 ;
      int_cm_VOL=0 ;
      despl_x =200;
      despl_y =550;
// Cargamos el fondo que queremos aparezca siempre
      background(blanco);    
      fill(negro);
      rect(0,0,200,height);
      img = loadImage("LOGO-B-PEQ.png");
      image(img,0,10); //cargamos la imagen-logo en la esquina izquierda 
   }


//Comenzamos la ejecución del código en bucle
void draw()
{
// Cargamos el fondo. Para el proyecto, por limitaciones de tiempo, hemos dejado únicamente 
// un pentgrama y ciertas notas prefijadas. En futuras versiones sería sencillo "pintar" 
// cada nota real según se fueran emitiendo.

  fondo();

// Comenzamos con la lectura del puerto serie.
//Si hay datos en el puerto serie, si el Arduino está envíando 
    while (myPort.available() >0)
    { 
    
//DATOS que envía Arduino       
         cm_FREC =  myPort.readStringUntil(lf); //leemos del sensor que marcará la FREC de la nota
         cm_VOL  =  myPort.readStringUntil(lf); //leemos del sensor que marcará el VOLUMEN de la nota

         // para evital NullPoiterException cuando arduino envía NULL
         if (cm_FREC != null && cm_VOL != null ){ 
         
         // traducimos lo que envía Arduino en String a int y luego a float para manejarlo en Processing.
             int_cm_FREC  = int(trim(cm_FREC));
             int_cm_VOL  = int(trim(cm_VOL));
             float_cm_FREC  = float(cm_FREC);
             float_cm_VOL  = float(cm_VOL);
// mapeamos los cm leidos del sensor que interpretamos como FREC, a los rangos de Frecuencia que queremos emitir de 3 octavas 
// The frequency value of the oscillator in Hz.
// y los cm leidos del sensor que interpretamos como VOL, a los rangos de Intensidad que admite el Oscilador de la clase SinOsc,
// The amplitude of the oscillator as a value between 0.0 and 1.0.

             frec_nota =map(float_cm_FREC,5,55,frec_min_nota,frec_max_nota);
             vol_nota  =map(float_cm_VOL,5,55,0.1,1.0);

//pasamos a string para pintar mejor por pantalla sólo con dos decimales 
             String str_frec_nota = nf(frec_nota, 0, 2); 
             String str_vol_nota = nf(vol_nota, 0, 2); 
   
// Damos paso a la MÚSICA. El Oscilador sonará si la los cm detectados por el sensor de FREC es <56,
// es decir, sólo sonará cuando tengamos la mano en los rangos aceptables
            if (int_cm_FREC<56){
            sin_sound.play(frec_nota,vol_nota);
            } else sin_sound.stop();   
        
// Damos paso a la IMAGEN. Pintaremos un serie de líneas que variarán según la variable FREC leída, tanto en posición como en color.   
            strokeWeight(15);
            colorMode(HSB,100,100,100);
            stroke_color =map(float_cm_FREC,5,66,0,100);
            stroke_sat =map(float_cm_VOL,5,66,0,100);
            stroke(stroke_color,stroke_sat,100);
            //eje x según la FREC, altura según VOL
            line(100+(int_cm_FREC*20),250,200+(int_cm_FREC*40),500);        
                
// Escribimos la información leída/pintada en la zona de Datos
            noStroke();
            fill(negro);
            rect(0,400,200,height); //limpiamos el marcador
            
// escribimos lo que envía Arduino
// Frecuencia en cm al sensor y emitida
            fill(blanco);
            text(int_cm_FREC +" cm", 20, 400); 
            fill(blanco);
            text(str_frec_nota +" Hz", 20, 450); 
// Volumen en cm al sensor y emitido            
            fill(blanco);
            text(int_cm_VOL +" cm", 20, 500); 
            fill(blanco);
            text("vol "+str_vol_nota, 20, 550); 
      
      }  //cierre de if (cm_FREC != null){ //para evitar NullPoiterException cuando arduino envía NULL         
   } //cierre de  while (myPort.available() >0)   
} //cierre de void draw()

 
