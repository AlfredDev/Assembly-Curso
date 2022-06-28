title Examen
IMPRIME_COLOR MACRO BUFFER
    mov al,BUFFER
    mov bl,10 ;;COLOR
    mov cx,1 ;;CUANTAS VECES SE PINTA
    mov ah,09h
    int 10h
ENDM

.model small
include libreria.lib ;;; 
.stack
.data
    Espacio DB 0Dh,0ah,'$' 
    var1 db '|*********MENU*********|','$'
    var2 db '1-LEER UNA CADENA','$'
    var3  DB 'Introduce una cadena: ','$'
    var4  DB 'Introduce el caracter a buscar: ','$'
    VAR5 DB '2-SALIR','$'
    var6 db '|*********BY ALFRED*********|','$'
    var_salir DB 'SALIR','$'
    cadena DB 10 DUP('1')
    char DB ' ','$' ;Almacen para el caracter
    INDEX DB (0)
.code
Main proc far
   PUSH DS
   push 0
   mov ax,@data
   mov ds,ax
   mov es,ax  ;;; Segemento extra apuntA al segmento de datos cuando se manajena cadenas
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    CODE SEGMENT       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
   ;; Despliege del menu 
   BAR:
        CALL LIMPIA
        POSICIONAR 2,27 ;LABEL MENU
        WRITE VAR1
        POSICIONAR 4,17 ;LABEL PIDE CADENA
        WRITE VAR2
        POSICIONAR 6,17 ;LABEL SALIR
        WRITE VAR5
   ;; V
   MOV AX,0
   INT 33H
   JE SALIDA ;
   CALL MOSTRAR ;;
  
   ;;
   CLICK:
        MOV AX,03H
        INT 33H
        CMP BX,1 ; 
        JE OPRIMIDO
        CMP BX,2 ; 
        JMP CLICK
        
        
   OPRIMIDO:
        ;;
        MOV AX,DX
        MOV BL,8
        DIV BL
        
        CMP AL,4
        JE VALIDA_RANGO_CADENA
        CMP AL,6
        JE VALIDA_RANGO_SALIR
        JMP CLICK  ;;; 
        
   SALIDA:
        JMP FIN
        
   VALIDA_RANGO_CADENA:
        ;;; 
        calCoord cx
        ;;; 
        CMP AL,16
        JBE CLICK
        CMP AL,34 ;;
        JAE CLICK
        JMP PEDIR_CADENA ;;
        
   VALIDA_RANGO_SALIR:
        calCoord cx
        CMP AL,16
        JBE CLICK
        CMP AL,24 ;;
        JAE CLICK
        JMP FIN
        
   PEDIR_CADENA:
        CALL LIMPIA
        WRITE VAR3 ;LABEL
        WRITE ESPACIO
        POSICIONAR 5,0
        WRITE VAR_SALIR ;LABEL
        POSICIONAR 1,0
        MOV SI,0 
        JMP DAME_CADENA
        
    CLEAR_CADENA:
         MOV CX,10
         L1:
            MOV CADENA[SI],49
            INC SI
            LOOP L1
        JMP BAR
        
    DAME_CADENA:
        call read
        cmp al,13 ;;;; 
        je AUX_CHAR ;; 
        mov cadena[si],al
        inc si
        jmp DAME_CADENA
        
    AUX_CHAR:
        ;;WRITE CADENA
        WRITE ESPACIO
        JMP DISPLAY_LABEL
   
    DISPLAY_LABEL:
        WRITE VAR4   
        JMP DAME_CHAR
     
        
    DAME_CHAR:
        POSICIONAR 3,32 ;
        MOV SI,0
        CALL READ
        MOV CHAR,AL
        CMP CHAR,13
        JE CLICK2
        JMP BUSQEUDA_CHAR
    
    CLICK2:
        CALL MOSTRAR;
        MOV AX,03H ;;PARA
        INT 33H
        CMP BX,1 ;LEFT
        JE PRESIONADO_SALIR
        CMP BX,2
        JMP CLICK2 ;
            
    PRESIONADO_SALIR:
        MOV AX,DX
        MOV BL,8
        DIV BL
        
        CMP AL,5
        JE VALIDA_RANGOSALIR2
        JMP CLICK2
             
    VALIDA_RANGOSALIR2:
        calCoord cx
        CMP AL,0
        JBE CLICK2
        CMP AL,5 ;
        JAE CLICK2
        JMP CLEAR_CADENA
        
    BUSQEUDA_CHAR:
        CLD
        MOV DI,OFFSET CADENA
        MOV CX,9
        REPNE SCASB
        JZ ENCONTRADO
        JMP DAME_CHAR
        
     ENCONTRADO:
        MOV SI,0
        MOV INDEX,0
        POSICIONAR 2,0
        JMP COLOREA_CHAR
    
        
     COLOREA_CHAR:
        CMP CADENA[SI],49 ; 
        JE DAME_CHAR  ;
        MOV AL,CHAR 
        CMP AL,CADENA[SI];
        JE PINTA_LETRA
        MOV AL,CADENA[SI] ; 
        imprimir02h AL
        INC SI
        INC INDEX
        JMP COLOREA_CHAR
     
     PINTA_LETRA:
        IMPRIME_COLOR AL ;;
        INC SI  ;
        INC INDEX ;;
        POSICIONAR 2,INDEX ;
        JMP COLOREA_CHAR
        
     FIN:
        CALL LIMPIA
        MOV AX, 4C00H
        INT 21H
ret    
Main endp
end main