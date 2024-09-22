include "emu8086.inc"

org 100h

.data
    nums db 10 dup(0)   ; Initialize nums array with size 10 and zero in all positions
    
.code
start:
    mov ax, @data       ; Move to AX @data
    mov ds, ax          ; Move to DS from AX
    mov cx, 10          ; Set loop counter
    mov di, offset nums ; Point to start of array
    
read_numbers:
    mov dx, cx          ; Save loop counter
    print "Escribe un numero entero (0-254): "
    call scan_num       ; Ask number, save to CX
    
    mov [di], cx        ; Save number to array
    inc di              ; Point to next position
    
    printn ""           ; Print new line
    
    xor cx, cx          ; Clear CX register
    mov cx, dx          ; Restore from loop counter
    loop read_numbers   ; If CX is zero continue, else decrement CX and go to label
    
    call bubble_sort    
    
    printn "Los números ordenados son:"
    mov cx, 10          ; Restart counter to print numbers
    xor di, di          ; Set to zero DI
    mov di, offset nums ; Point to start of array
    
print_numbers:
    printn ""
    xor ax, ax          ; Clear AX register
    mov ax, [di]        ; Move number to AX
    xor ah, ah          ; Clear AH
    call print_num_uns  ; Print unsigned number
    inc di              ; Point to next number in array
    loop print_numbers  ; If CX is zero continue, else decrement CX and go to label
    
    ret   
    
bubble_sort:
    mov cx, 9           ; Set to last position in array
outer_loop:
    mov si, offset nums ; Point to first number in array
    mov di, si          ; Move number position to DI
    inc di              ; Point to next number
    mov bx, cx          ; Save counter 
inner_loop:
    mov al, [si]        ; Move first number to AL
    mov ah, [di]        ; Move second number to AH
    cmp al, ah          ; Compare AL and AH
    jae no_swap         ; If AL >= AH, then go to label
    ; Interchange if not true
    mov [si], ah
    mov [di], al
no_swap:
    inc si              
    inc di              
    dec bx              
    jnz inner_loop      ; If BX != 0 jump to label
    dec cx              ; Decrement counter
    jnz outer_loop      ; If CX != 0 jump to label
    ret

define_print_string
define_print_num_uns
define_scan_num
end                      
