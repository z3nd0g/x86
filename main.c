#include <stdio.h>
#include <stdlib.h>
#include <allegro.h>
#include <math.h>
#include "wykres.h"

#define SCREEN_WIDTH 512
#define SCREEN_HEIGHT 512

BITMAP *bmp = NULL; //obrazek
double a, b, c, S; //parametry

int main(){

    a = 1.0;
    b = 0.0;
    c = 0.0;
    S = 1.0;

    //inicjalizacja
    allegro_init();
    install_keyboard();
    set_gfx_mode(GFX_AUTODETECT_WINDOWED, SCREEN_WIDTH, SCREEN_HEIGHT, 0, 0);

    //tworzymy bitmapę w odcieniach szarości (8 bitów na piksel)
    bmp = create_bitmap_ex(8, SCREEN_WIDTH, SCREEN_HEIGHT); 
 
    while(!key[KEY_ESC]){
        clear_to_color(bmp, 255);
        vline(bmp, SCREEN_WIDTH/2, 0, SCREEN_HEIGHT, 0);
        hline(bmp, 0, SCREEN_HEIGHT/2, SCREEN_WIDTH, 0);

        //wpisz wykres do bufora
        wykres(bmp->line, bmp->w, bmp->h, a, b, c, S); 

        //wyświetl bmp na ekranie
        blit(bmp, screen, 0, 0, 0, 0, bmp->w, bmp->h);
        
        readkey();//zatrzymanie programu do czasu naciśnięcia dow. klawisza
        if(key[KEY_A]){a +=0.05;}
        else if(key[KEY_S]){a -=0.01;}
        else if(key[KEY_B]){b +=0.01;}
        else if(key[KEY_N]){b -=0.01;}
        else if(key[KEY_C]){c +=0.01;}
        else if(key[KEY_V]){c -=0.01;}
    }

    destroy_bitmap(bmp);
    allegro_exit();
    return(0);
}
