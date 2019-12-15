//Cargamos una paleta básica de colores por si quisiéramos cambiar de gama facilmente.
color blanco = #FFFFFF;
color negro = #000000;

//COLORES_A
color blanco1 = #F9D5BB;
color negro1 = #D35656;


//COLORES_B
color blanco2 = #293462;
color negro2 = #357376;


//COLORES_C
color blanco3 = #F9D5BB;
color negro3 = #F66767;


//COLORES_D
color blanco4 = #110133;
color negro4 = #00918E;

void fondo () {

//Pentagrama
        strokeWeight(1);
        stroke(negro);
        for (int i = 0; i < 5; i++) {
          line(200,100+(i*20), width, 100+(i*20));}
         //línea de puntos para Do menor?
        strokeWeight(1);
        stroke(negro);
        for (int i = 200; i < width; i = i+10){
          point(i, (despl_y/5)+100); }  
          
// Pendiente optimizar usando un vector para melodía o un bucle
// Según la posición de la nota "nota_to_pos" la nota a pintar será un do,re,mi,fa..sucesivamente desde el 1,2,3,4... 
// Lo realizamos llamando a las funciones "pinta_nota" que dibuja la elipse
// y a la función nota_to_pos que la situa en la línea del pentagrama
        pinta_nota(despl_x+100,(despl_y/5)+(nota_to_pos(2)*10)); //pintamos un RE
        pinta_nota(despl_x+200,(despl_y/5)+(nota_to_pos(5)*10)); // pintamos un SOL
        pinta_nota(despl_x+300,(despl_y/5)+(nota_to_pos(7)*10)); // pintamos un SI
        pinta_nota(despl_x+400,(despl_y/5)+(nota_to_pos(11)*10));
        pinta_nota(despl_x+500,(despl_y/5)+(nota_to_pos(9)*10));
        pinta_nota(despl_x+600,(despl_y/5)+(nota_to_pos(8)*10)); //pintamos un DOa
        pinta_nota(despl_x+700,(despl_y/5)+(nota_to_pos(6)*10)); //pintamos un LA
        pinta_nota(despl_x+800,(despl_y/5)+(nota_to_pos(10)*10));
        pinta_nota(despl_x+900,(despl_y/5)+(nota_to_pos(2)*10)); //pintamos un RE
        pinta_nota(despl_x+1000,(despl_y/5)+(nota_to_pos(1)*10));
        pinta_nota(despl_x+1100,(despl_y/5)+(nota_to_pos(2)*10)); //pintamos un RE
       //}
       
         
//Matriz de puntos, meramente decorativa, aunque sería fácilmente dinamizable con alguno de los parámetros leidos de Arduino.
//strokeWeight(2);
//stroke(negro3);
//for (int i = 200; i < width; i = i+5){
//   for (int j = 500; j < 600; j = j+5){
//   point(i, j); } }   
             
       
}
