; Gutierrez Perez Daniela
; Martínez Florez Uri
bits 16
org 0x100

section .data
    prompt db "Ingresa un entero (0-99): $"  ; Saves a String
    result_msg db "Numeros ordenados: $"  ; Saves a String
    newline db 0x0d, 0x0a, "$"  ; String saves a new line
    nums times 10 db 0          ; Array to save 10 numbers

section .bss                ; Declare variables without initializing 
    input resb 4            ; Reserve 4 bytes called input

section .text
    global _start

_start:
    ; Read 10 numbers from keyboard
    mov cx, 10          ; Number counter
    mov di, nums        ; Point to start of array
    
read_numbers:
    mov ah, 9           ; DOS call to show a String$
    mov dx, prompt      ; Move message to memory location
    int 0x21            ; Make interrupt for previous call

    call read_number

    mov [di], ax        ; Save entered number in the array 
    inc di              ; Increment SI to point to next space in array
    
    mov ah, 9           ; DOS call to show a String$
    mov dx, newline     ; Set message to show
    int 0x21            ; Make interrupt for previous call
    loop read_numbers   ; Decrease CX, jump to label if CX is not zero

    call bubble_sort 

    ; Show ordered numbers
    mov ah, 9           ; DOS call to show a String$
    mov dx, result_msg  ; Move message to memory location
    int 0x21            ; Make interrupt for previous call

    mov cx, 10          ; Restart counter for another loop
    mov si, nums        ; Point to start of array

print_numbers:
    ; Print number
    call print_number
    
    ; Print new line
    mov ah, 9           ; DOS call to show a String$
    mov dx, newline     ; Move message to memory location
    int 0x21            ; Make interrupt for previous call
    inc si              ; Point to next number in array
    loop print_numbers  ; Decrease CX, jumto to label if CX is not zero
    
    ; Finish program
    mov ah, 0x4c        ; DOS call to return control to OS
    int 0x21            ; Make interrupt for previous call

read_number:
    xor ax, ax          ; Set to zero AX
    mov ah, 0x0a        ; DOS call to read a String from keyboard
    lea dx, [input]     ; Sets buffer size to read from DOS call
    int 0x21            ; Make interrupt for previous call

    ; From [input] first byte is buffer size, 
    ; second byte if number of chars written by the user
    ; From third byte and forward is the content of the user string

    ; Convert number to binary
    lea si, [input + 2] ; Move first chart to SI register
    xor ax, ax          ; Initialize AX to zero in all bits
    xor bx, bx          ; Initialize BX to zero in all bits
    mov al, [si]        ; Move char to AL
    sub al, "0"         ; Convert from ASCII to number
    mov bl, al          ; Save value to BL

    cmp byte [input + 1], 1  ; If input contains two numbers
    je short end_read   ; Short jump to label

    inc si              ; Point to next char in String
    mov al, [si]        ; Move char to AL
    sub al, "0"         ; Convert from ASCII to number
    mov bh, al          ; Move second digit to bh
    xor ax, ax          ; Zero bits in all AX
    mov al, bl          ; Move first digit to AX
    mov bl, 10          ; Set BL to 10 for multiplication
    mul bl              ; AX = AX * BL
    add al, bh          ; Add second digit to first digit
end_read:
    xor si, si          ; Set to zero SI
    ret

bubble_sort:
    mov cx, 9           ; Point counter to last number
outer_loop:
    mov si, nums        ; Point to start of array
    mov di, nums + 1    ; Point to second element
    mov bx, cx          ; Save counter
inner_loop:
    mov al, [si]        ; Move first item of array to AL
    mov ah, [di]        ; Move second item of array to AH
    cmp al, ah          ; Compare items
    jae no_swap         ; Short Jump if First Operand is greater or equal to Second Operand
    ; Interchange if out of order
    mov [si], ah
    mov [di], al
no_swap:
    inc si
    inc di
    dec bx
    jnz inner_loop      ; If BX not zero, jump to label
    dec cx
    jnz outer_loop      ; If CX not zero, jump to label
    ret

print_number:
    mov ax, [si]        ; Move to AX for printing
    xor ah, ah          ; Clear high part or register
    mov bl, 10          ; Set BX to 10
    div bl              ; AL = AX / BX; AH = remainder
    ; AL = dozens ; AH = units
    add al, "0"         ; Convert dozens to ASCII
    add ah, "0"         ; Convert units to ASCII

    mov dh, ah          ; Move units to DH
    mov dl, al          ; Move dozens for printing

    mov ah, 2           ; DOS call for printing a char
    int 0x21            ; Make interrupt for previous call

    mov dl, dh          ; Move units for printing
    mov ah, 2           ; DOS call for printing a char
    int 0x21            ; Make interrupt for previous call

    ret
