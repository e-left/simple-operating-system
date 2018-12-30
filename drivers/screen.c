#include "screen.h"
#include "../kernel/low_level.h"

int get_cursor() {
    port_byte_out(REG_SCREEN_CTRL, 14); //the device uses the control register as an index to select the individual registers that we are interested in. in this case register 14 is the high byte of the cursor offset and register 15 the low byte
    int offset = port_byte_in(REG_SCREEN_DATA) << 8;
    port_byte_out(REG_SCREEN_CTRL, 15);
    offset += port_byte_in(REG_SCREEN_DATA);
    return offset*2;
}

void set_cursor(int offset) {
    offset /= 2; //we change from 2 byte offset to single byte offset,since the cursor uses that instead of the 2 cell mechanism
    //same as the get cursor function,only now we write on the corresponding data registers
    port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
    port_byte_out(REG_SCREEN_CTRL, 15);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset));
}

int get_screen_offset(int row, int col) {
    int offset;
    offset = (row*MAX_COLS + col)*2; //the formula is simple,but remember to multiply by 2 since every cell occupies 2 bytes on memory
    return offset;
}

int handle_scrolling(int offset) {

}


void print_char(char c, int row, int col, char attribute) {
    unsigned char *vidmem = (unsigned char *)VIDEO_ADRESS;

    if(!attribute) {
        attribute = WHITE_ON_BLACK;
    }

    int offset;
    //if row and col are non negative valid screen offsets,use them
    if((row >= 0)&& (row < MAX_ROWS) &&(col >= 0) && (col < MAX_COLS)) {
        offset = get_screen_offset(row, col);
    }   else    {
        //we just get the cursor position
        offset = get_cursor();
    }

    if(c == '\n') {
        //we check if the character is a newline so we can adjust the new offset properly
        int curr_row = offset/(2*MAX_COLS);
        offset = get_screen_offset(curr_row,MAX_COLS-1);
    }   else    {   //else we just write the character and the attributes to the corresponding memory locations
        vidmem[offset] = c;
        vidmem[offset + 1] = attribute;
    }

    offset += 2;    //remember each cell occupies two bytes on memory
    offset = handle_scrolling(offset);  //handle scrolling for when we get at the end of the screen

    set_cursor(offset); //update our cursor position 
}

void print_at(char* string, int col, int row) {
    if((row >= 0)&& (row < MAX_ROWS) &&(col >= 0) && (col < MAX_COLS)) {
        //if provided position is valid we use that
        set_cursor(get_screen_offset(row,col));
    }

    int i;
    for(i = 0;string[i] !=0;i++){
        print_char(string[i],row,col,WHITE_ON_BLACK);
    }
}

void print(char* string) {
    print_at(string, -1, -1);
}

void clear_screen() {
    int row = 0;
    int col = 0;

    for(row = 0;row<MAX_ROWS;row++) {
        for(col = 0;col<MAX_COLS;col++) {
            print_char(' ',row,col,WHITE_ON_BLACK);
        }
    }

    set_cursor(get_screen_offset(0,0));

}
