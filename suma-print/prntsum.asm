bits 16
org 0x100 

section .data
  n1 db 200     ; Define byte variable n1 with value 200
  n2 db 4       ; Define byte variable n2 with value 4
  n3 db 0       ; Define byte variable n3 initialized to 0
  digits db 5 dup(0) ; Define an array for saving digits

section .text
  mov al, [n1]    ; Move the value of n1 into the AL register
  mov bl, [n2]    ; Move the value of n2 into the BL register
  add al, bl    ; Add the value in BL to AL (n1 + n2)
  mov [n3], al  ; Store the result (sum) from AL into the memory location of n3
  
  mov si, 0     ; Digit counter set in SI, starts in 0, 8086 only allows BX, SI, DI, BP to be used with displacement

  mov al, [n3]  ; Load the number form n3 to AL

convert_loop:
  mov ah, 0     ; Set AH to 0 before division
  mov bl, 10    ; Set BL to 10
  div bl        ; Divides AX/BL => AL = quotient, AH = Remainder
  add ah, 0x30  ; Add 0x30 to convert digit to ASCII
  mov [digits + si], ah ; Saves the digit to the digits array
  inc si        ; Increments the digit counter

  cmp al, 0     ; Compares AL (quotient) with zero
  jne convert_loop ; If previous comparison is false, go to definition (convert_loop)

print_loop:
  dec si        ; Decrement digit counter to point to the last digit
  mov dl, [digits + si] ; Moves the digit to the DL register
  mov ah, 0x02  ; Calls DOS to print a char
  int 0x21      ; Make interrupt for previous call

  cmp si, 0     ; Compares digit counter to zero
  jne print_loop; If previous comparison is false, go to print_loop


  mov ah, 0x4c  ; Calls DOS to interrupt the program
  int 0x21      ; Make the interrupt
