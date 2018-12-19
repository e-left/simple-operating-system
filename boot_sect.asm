[org 0x7c00]

    mov [BOOT_DRIVE], dl
    
    mov bp, 0x8000
    mov sp, bp

    mov bx, 0x9000
    mov dh, 5
    mov dl, [BOOT_DRIVE]

    call disk_load

    mov dx, [0x9000]
    call print_hex

    mov dx, [0x9000 + 512]
    call print_hex



loop:
    jmp loop

%include "print_string.asm"
%include "print_hex.asm"
%include "disk_load.asm"

BOOT_DRIVE: db 0

times 510-($-$$) db 0 ; Pads the boot sector binary up to 510 bytes so that the magic bytes are properly aligned

dw 0xaa55 ; Magic bytes so that the system knows this is a valid boot sector


times 256 dw 0xfefe
times 256 dw 0xadad
