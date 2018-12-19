[bits 16]
print_string:
    pusha

    mov ah, 0x0e
    

rep567:
    
    mov al, [bx]
    cmp al, 0 
    je end989
    
    int 0x10

    inc bx
    jmp rep567



end989:
    popa 
    ret
