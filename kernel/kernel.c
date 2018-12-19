void func() {}

int main() {
    char* video_memory = (char*)0xb8000; //Create a pointer to a character and point it to the top left corner of our screen

    *video_memory = 'X'; //Write the character 'X' to the pointer that points to the top left corner of the screen
    func();
}
