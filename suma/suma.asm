bits 16
org 0x100 

section .data
  n1 db 200     ; Define byte variable n1 with value 200
  n2 db 4       ; Define byte variable n2 with value 4
  n3 db 0       ; Define byte variable n3 initialized to 0

section .text
  mov al, n1    ; Move the value of n1 into the AL register
  mov bl, n2    ; Move the value of n2 into the BL register
  add al, bl    ; Add the value in BL to AL (n1 + n2)
  mov [n3], al  ; Store the result (sum) from AL into the memory location of n3

  mov dl, [n3]  ; Move the value stored at n3 into the DL register
  mov ah, 0x02  ; Set AH to 0x02 (DOS interrupt to write a character to stdout)
  int 0x21      ; Call DOS interrupt 21h to print the character in DL

  mov ah, 0x4C  ; Set AH to 0x4C (DOS interrupt to terminate the program)
  int 0x21      ; Call DOS interrupt 21h to return control to the operating system
