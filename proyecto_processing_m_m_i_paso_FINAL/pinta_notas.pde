// Función que dibuja una nota (elipse) sobre el pentagrama según un "nota numérica" dada. 
// Da la posición y del pentagrama dibujado
// siendo el 1: do, el 2:re, el 3:fa y así sucesivamente...,
// mapeamos desde un Do bajo a un Fa alto para no salirnos mucho del pentagrama pintado. Será sólo un ejemplo.
int nota_to_pos (int nota){
  
  if (nota==1){ //DO
    return 10;}
    else if (nota==2){ //RE
    return 9;}
    else if (nota==3){ //MI
    return 8;}
    else if (nota==4){ //FA
    return 7;}
    else if (nota==5){ //SOL
    return 6;}
    else if (nota==6){ //LA
    return 5;}
    else if (nota==7){  //SI
    return 4;}
    else if (nota==8){  //DOa
    return 3;}
    else if (nota==9){  //REa
    return 2;}
    else if (nota==10){  //MIa
    return 1;}
    else if (nota==11){  //FAa
    return 0;}
    else return 11;
     
}

// Función "pinta_nota" que dibujará una elipse rotada 30º, para asemejar una nota, en la posición x,y dadas
// (no entraremos en duración de las mismas, entendiendo identificar redondas, negras, corcheas...)
void pinta_nota (int x,int y) {
   noStroke();
   fill(negro);
   pushMatrix();
   // move the origin to the pivot point
   translate(x,y);
   // then pivot the grid
   rotate(radians(-30)); 
   //ellipse(width/2,height/2,30,20); 
   ellipse(0,0,25,18); 
   popMatrix();  
  }
