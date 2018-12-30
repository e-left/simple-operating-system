#ifndef VID_INC
#define VID_INC


#define VIDEO_ADRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80

#define WHITE_ON_BLACK 0x0f

#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5

void clear_screen();
void print_char(char c,int row,int col,char attribute);
void print_at(char* string,int row,int col);
void print(char* string);

#endif
