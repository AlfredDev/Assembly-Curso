TITLE MenuM,
.286
;;Macro para escribir en pantalla
Write MACRO buffer
    Mov ah,09h
    Mov dx,offset buffer
    Int 21h
ENDM

;;; Macro para posicionar el cursor
Posicionar MACRO coordx,coordy
    MOV AH,02H
    MOV DH,coordx
    MOV DL,coordy
    MOV BH,0
    INT 10H
ENDM

;;;Macro para imprimir las operaciones
imprimir macro buffer
   mov ah,02
   mov dl,buffer
   int 21h
endm

;macro que obtiene la coordenada en caracteres este resultado se devuelve en al
calCoord macro buffer
   mov ax,buffer
   mov bl,8
   div bl
endm

Spila SEGMENT STACK
    DB 32 dup ('stack__')
Spila ENDS
Sdatos SEGMENT
    Dato DB 0
    coordx db ?, '$'
    coordy db ?, '$'
    Espacio DB 0DH,0Ah,'$'
    CADENA  DB 'MENU $'
    CADENA1 DB '1 SUMAR $'
    CADENA2 DB '2 Restar $'
    CADENA3 DB '3 Salir $'
    LETRERO1 DB 'Introduce un numero: $'
    LETRERO2 DB 'Resultado: $'
Sdatos ENDS
Scodigo SEGMENT 'code'
    Assume ss:Spila, ds:Sdatos, cs:Scodigo
    
    ;;Procedimiento para leer por teclado
    read PROC NEAR
        Mov ah,01h
        Int 21h
    ret
    read ENDP
    
    LIMPIA PROC NEAR 
        mov        ah, 0
        ;bh para asignar color a la pantalla bh, 00 el primer d?gito es para el fondo y el segundo para el color de la letra
        mov        cx,00h
        mov        dx, 184fh
        mov        al, 3
        int        10h
        ret
    LIMPIA ENDP
    
    mostrar proc
     mov ax,1
     int 33h
     ret
    mostrar endp 
    
    SUMAR PROC
        WRITE LETRERO1
        CALL READ
        MOV DATO,AL
        WRITE ESPACIO
        WRITE LETRERO1
        CALL READ
        ADD AL,DATO
        SUB AL,30H
        WRITE ESPACIO
        WRITE LETRERO2
        IMPRIMIR AL
        RET
     SUMAR ENDP
     
     RESTAR PROC
        WRITE LETRERO1
        CALL READ
        MOV DATO,AL
        WRITE ESPACIO
        WRITE LETRERO1
        CALL READ
        SUB DATO,AL
        ADD DATO,30H
        WRITE ESPACIO
        WRITE LETRERO2
        IMPRIMIR DATO
        RET
     RESTAR ENDP
    
     Main PROC FAR
     Push ds
     Push 0
     Mov ax,sdatos
     Mov ds,ax
    ;;;; Llamamos el procedimiento para limpiar pantall
    CALL LIMPIA
    
    MENU:
        POSICIONAR 5,35
        WRITE CADENA
        POSICIONAR 7,30
        WRITE CADENA1
        POSICIONAR 9,30
        WRITE CADENA2
        POSICIONAR 11,30
        WRITE CADENA3
        
    ;;; Verificamos que exista un mouse conectado
    mov ax,0
    int 33h
    ;;; Si no sale
    JE SALIR
    ;;; Muestra el puntero del moues
    CALL MOSTRAR
    
    BUCLE:
    ;;;Obtiene la posici?n y el estado del puntero
        MOV AX,03H
        INT 33H
    ;evaluamos que se haya oprimido el clic izquierdo
    TEST BX,1
    JNE  oprimido
    JMP  BUCLE
    
    OPRIMIDO:
   ;calculamos la coordenada en y, el dato se almacena en al
        MOV AX,DX
        MOV BL,8
        DIV BL
        
        CMP AL,7
        JE SUMA
        CMP AL,9
        JE RESTA
        CMP AL,11
        JE SALIR
        
    SUMA:
        ;;; Calculamos el rango para x, cx(columna)
        calCoord cx
        ;;; Si es menor que 29 esta fuera de rango
        CMP AL,29
        JBE BUCLE
        ;;;; Si es mayor al rango
        CMP AL,37
        JAE BUCLE
        
        CALL LIMPIA
        
        CALL SUMAR
        JMP MENU
        
    RESTA:
        ;;; Calculamos el rango para x, cx(columna)
        calCoord cx
        ;;; Si es menor que 29 esta fuera de rango
        CMP AL,29
        JBE BUCLE
        ;;;; Si es mayor al rango
        CMP AL,38
        JAE BUCLE
        
        CALL LIMPIA
        CALL RESTAR
        JMP MENU
        
    SALIR:
       ;;; Calculamos el rango para x, cx(columna)
        calCoord cx
        ;;; Si es menor que 29 esta fuera de rango
        CMP AL,29
        JBE BUCLE
        ;;;; Si es mayor al rango
        CMP AL,37
        JAE BUCLE
        
      MOV AX, 4C00H
      INT 21H
        
    
        
    Main ENDP
Scodigo ENDS
END main