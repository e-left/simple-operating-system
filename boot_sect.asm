[org 0x7c00]
KERNEL_OFFSET equ 0x1000    ;memory offset where our kernel will be loaded

    mov [BOOT_DRIVE], dl ;Bios stores boot drive in dl when booting,might be useful later

    mov bp, 0x9000  ; Set up the stack in 16 bit mode
    mov sp, bp

    mov bx, MSG_16_BIT  ; We successfully verify that we have indeed booted in 16 bit mode
    call print_string
    
    call load_kernel    ;loading our kernel

    call switch_to_32   ; We never return from here

    jmp $


load_kernel:
    mov bx, MSG_LOADING_KERNEL
    call print_string   ;letting the user know we are loading the kernel

    mov bx, KERNEL_OFFSET
    mov dh, 15
    mov dl, [BOOT_DRIVE]
    call disk_load  ;setting up the parameters and loading our kernel
    
    ret

[bits 32]

BEGIN_PM:   ; Known routine we chose to jump to when entering 32 bit protected mode
    
    mov ebx, MSG_32_BIT
    call print_string_32

    call KERNEL_OFFSET  ;execute our loaded kernel code

    jmp $


%include "./assembly/print_string.asm"
%include "./assembly/disk_load.asm"
%include "./assembly/gdt.asm"
%include "./assembly/print_string_32.asm"
%include "./assembly/switch_to_32.asm"

MSG_16_BIT: db  'Started in 16 - bit Real Mode' , 0
MSG_32_BIT:  db 'Successfully entered 32 bit protected mode',0
BOOT_DRIVE db 0
MSG_LOADING_KERNEL db "Loading kernel into memory",0

times 510-($-$$) db 0 ; Pads the boot sector binary up to 510 bytes so that the magic bytes are properly aligned

dw 0xaa55 ; Magic bytes so that the system knows this is a valid boot sector
