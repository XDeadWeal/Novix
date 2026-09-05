#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define WIDTH 80
#define HEIGHT 25

void clear_screen() {
    printf("\033[2J\033[H");
}

void draw_taskbar() {
    printf("\033[%d;1H", HEIGHT);
    for (int i = 0; i < WIDTH; i++) {
        printf("=");
    }
    printf("\033[%d;1H", HEIGHT);
    printf("[ Start ] Tasks: 0  %02d:%02d", 14, 30);
}

void draw_desktop() {
    clear_screen();
    printf("\033[1;1HNovix OS Desktop");
    printf("\033[3;1HPress 's' for Start Menu");
    printf("\033[5;1HWelcome to Novix!");
    draw_taskbar();
}

void draw_start_menu() {
    int x = 10, y = 5;
    printf("\033[%d;%dH+----------------+", y, x);
    printf("\033[%d;%dH|    START MENU    |", y+1, x);
    printf("\033[%d;%dH+----------------+", y+2, x);
    printf("\033[%d;%dH| 1. Applications  |", y+3, x);
    printf("\033[%d;%dH| 2. Settings     |", y+4, x);
    printf("\033[%d;%dH| 3. Shutdown     |", y+5, x);
    printf("\033[%d;%dH+----------------+", y+6, x);
}

int main() {
    clear_screen();
    draw_desktop();
    printf("\n\nPress 's' for Start Menu, 'q' to quit...");
    
    char c = getchar();
    if (c == 's') {
        draw_start_menu();
        printf("\nPress Enter to continue...");
        getchar();
        getchar();
    }
    
    clear_screen();
    return 0;
}