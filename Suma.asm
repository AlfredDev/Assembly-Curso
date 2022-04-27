TITLE prueba,
.286
Spila SEGMENT STACK
    DB 32 dup ('stack__')
Spila ENDS
Sdatos SEGMENT
    Dato DB (0)
Sdatos ENDS
Scodigo SEGMENT 'code'
    Assume ss:Spila, ds:Sdatos, cs:Scodigo
    Main PROC FAR
    Push ds
    Push 0
    Mov ax,sdatos
    Mov ds,ax
    ;;;;;;;leer dos numeros;;;;;;;
    Mov ah,01h
    Int 21h
    Mov dato,al
    Mov ah,01h
    Int 21h
    ;;;;;Sumar dos numeros;;;;;;
    Add al,dato
   

    
   ;;;;; Limpiar interfaz ;;;;;
    Mov ah,6h
    mov cl,0 ;Inicio de la columna
    mov ch,0 ;Inicio de la fila
    mov dl,4Fh ;fin de la columnfa
    mov dh,18h ; fin de la fila
    mov bh,9   ; Color
    int 10h
    
    ;;;;;;Escribir en monitor;;;;;;;
    Sub al,30h
    Mov dl,al 
    mov ah,02h
    Int 21h
    Ret
    Main ENDP
Scodigo ENDS
END main