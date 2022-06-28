title BucarChar
.286

write macro buffer
    mov ah,09h
    lea dx,buffer
    int 21h
endm

leer macro  
    mov ah,01h
    int 21h

.model small
.stack
.data
    arreg db 7 dup (?),'$'
    cad1 db 10,13,'Ingrese una palabra: ','$'
    cad2 db 'Ingrese un caracter','$'
    msg db 'Caracter  encontrado','$'
    cadena db 'hola','$'
    char db 'o'
.code 
Main proc far
 PUSH DS
    push 0
    mov ax,@data
    mov ds,ax
    mov es,ax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; leer caracter
   
write cad1
   mov si,0
   leyendo:
   leer 
   cmp al,13
   je pedir
   mov arreg[0],al
   inc si
   jmp leyendo

   pedir:
   write cad2

    cld
    Lea di,arreg
    mov cx,1
    repne scasb

    iguales:
        write msg 

 fin:
 ret    
Main endp
end main    
