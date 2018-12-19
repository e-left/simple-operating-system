[bits 16]

switch_to_32:   ; Subroutine used to swtich to 32 bit protected mode

    cli ; We begin by clearing and disabling interupts
    lgdt [gdt_descriptor]   ; We load our gdt

    ; We need to set a bit to 1 on the special register cr0 that we cannot manipulate, so this is necessery
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SEG:init_32   ; Make a far jump to force the switch

[bits 32]

init_32:    ; Initialize stack and registers
            ; Since our old segments are meaningless, we point our segment registers to the data segment we defined in gdt

    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax 
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000    ; Update stack position so it's correct
    mov esp, ebp

    call BEGIN_PM       ; Finally call some well known label
