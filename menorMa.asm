TITLE MENOR_ARRAY,
.286

Write MACRO buffer
    Mov ah,09h
    Mov dx,offset buffer
    Int 21h
ENDM

Spila SEGMENT STACK
    DB 64 dup ('stack__')
Spila ENDS
Sdatos SEGMENT
    VECTOR DB 3 DUP(0) ;;; Declaracion del arreglo
    Espacio DB 0DH,0Ah,'$'
    CADENA1 DB 'INTRODUCE UN NUMERO: $'
    CADENA2 DB 'EL NUMERO MENOR ES: $'
    MENOR DB (0)
Sdatos ENDS

Scodigo SEGMENT 'code'
    Assume ss:Spila, ds:Sdatos, cs:Scodigo
    Main PROC FAR
    Push ds
    Push 0
    Mov ax,sdatos
    Mov ds,ax
    
    ;;;;;,;;;;;;; CODE ;;;;;;;;;;;;;;;;;;;;
    MOV SI,0
    
    ;;;;;;;;; Llenado del arreglo
    CICLO:
        WRITE CADENA1       ;;Mensaje que pide el numero
        MOV AH,01H          ;;Interrupcion
        INT 21H             ;;Fin de la interrupcion
        WRITE ESPACIO       ;;; Imprime un espacio
        MOV VECTOR[SI],AL   ;;;;Indroduce el numero tecleado al arreglo
        INC SI              ;;;; Incrementa SI
        CMP SI,2            ;;;; Compara SI
        JBE CICLO           ;;;; Si es menor o igual regresa al ciclo
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;;;;;;;;; Buscar el menor del arreglo;;;;;;;;
    MOV SI,0                    ;;Iniciamos a SI con 0
    MOV AL,VECTOR[SI]           ;;Movemos al registro AL el elemento de la posicion inicial, Al guardara el numero menor
    FOR:
        CMP VECTOR[SI+1],AL     ;;Compara el elemento de la posicion SI + 1 con el registro AL 
        JBE CAMBIO              ;;Si es menor o igual, saltara a la etiqueta Cambio
        JMP INCREMENTA          ;;Si es mayor, saltara a la etiqueta INCREMENTA
        
    INCREMENTA:
        INC SI                                  
        CMP SI,2
        JB FOR                  ;;Si es menor salta hacia la Etiqueta FOR
        JMP IMPRIMIR            ;;Si es mayor salta a la etiqueta Imprimir
        
    CAMBIO:
        MOV AL,VECTOR[SI+1]     ;;Movemos a el elemento del vector a AL
        JMP INCREMENTA          ;;Salta a la etiqueta INCREMENTA
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;;;;;;;;;;;;;;;;; IMPRIMIR EL MENOR;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    IMPRIMIR:
        WRITE CADENA2           
        MOV DL,AL               ;; Movemos el numero menor (AL) hacia el registro DL
        MOV AH,02H              ;; Llamamos la interrupcion
        INT 21H
       ret
    Main ENDP
Scodigo ENDS
END main