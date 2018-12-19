;load dh sectors on dl disk device to es:bx

disk_load:
    push dx

    mov ah, 0x02 ;bios subroutine
    mov al, dh ;read dh sectors
    mov ch, 0x00 ;culinder 0
    mov dh, 0x00 ;head 0
    mov cl, 0x02 ;second sector -> after the boot sector

    int 0x13 ;call interupt 

    jc disk_error
    
    pop dx
    cmp dh, al
    jne disk_error
    ret


disk_error:
    mov bx, DISK_ERR_MSG
    call print_string
    jmp $

DISK_ERR_MSG db "Disk read error!",0
    
