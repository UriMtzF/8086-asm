bits 16               ; Se asegura que se está trabajando en 16 bits
org 0x100             ; Inicia el código en 0x100 (necesario para todos los COM)

section .text
  mov dx, msg         ; Carga la dirección del mensaje en dx
  mov ah, 0x09        ; Servicio de DOS para imprimir cadena
  int 0x21            ; Interrupción de DOS

  mov ah, 0x4C        ; Servicio de DOS para interrumpir el programa
  int 0x21            ; Interrupción de DOS

section .data
msg db "Hola mundo$", 0
