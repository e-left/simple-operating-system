; GDT
; Probably most error-prone file so far

gdt_start:

gdt_null:   ; First descriptor, must be null, mandatory for error-catching
    dd 0x0  ; All descriptors have a length of 64 bits or 8 bytes
    dd 0x0  ; Format can be easily found online or in the book

gdt_code:   ; Code segment descriptor
            ; base = 0x0, limit = 0xfffff (will be expanded with a special flag to 0xfffff000)
            ; 1st flags: present = 1(exists on memory), priviledge = 00(highest priviledge available), descriptor type = 1 => 1001b
            ; type flags: code = 1(code segment), conforming = 0(lower priviledge segments can't access this segment-basic memory protection), readable = 1(read permissions), accessed = 0(used by cpu for debugging purposes) => 1010b
            ; 2nd flags: granularity = 1(the flag that expands our limit), 32-bit-default = 1(the segment will hold 32 bit code and not 16 bit), 64-bit-seg = 0(this will be a 32 bit segment not a 64 bit), AVL = 0(we don't need to use this) => 1100b

    dw 0xffff   ; Limit bytes 0-15
    dw 0x0      ; Base bits 0-15
    db 0x0      ; Base bits 16-23
    db 10011010b; First flags and type flags
    db 11001111b; Second flags and limit bits 16-19
    db 0x0      ; Base bits 24-31

gdt_data:   ; Data segment descriptor
            ; Same as code segment descriptor, apart from the following changes:
            ; type flags: code = 0, expand-down = 0(so that the segment can expand down and occupy as much memory as needed), writable = 1(we need to be able to write data), accessed = 0 => 0010b

    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0 

gdt_end:    ; label used so that we can easily calculate addresses

gdt_descriptor:     ; Gdt descriptor
    dw gdt_end - gdt_start - 1  ; Size of our gdt, always 1 less than true size(base 0 counting system)
    dd gdt_start    ; Beginning of our gdt

; Defines, so that we can easily use the offsets of segments inside gdt when we need to
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start


    
