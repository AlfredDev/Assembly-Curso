.286

;macro que posiciona el cursor en la fila y columna indicada
posicionar macro fila, columna
               mov ah,02h
               mov dh,fila
               mov dl,columna
               mov bh,00h
               int 10h
endm

;macro que despliega un texto
escribir macro letrero
             mov ah, 09h
             lea dx, letrero
             int 21h
endm

;macro que imprime un digito
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
          DB 32 dup ('stack___')
Spila ENDS

Sdatos SEGMENT
    Espacio DB 0Dh,0ah,'$'        ;cadena que se utiliza para imprimir un enter
    ;opciones del menu
    titulo  DB 'Menu ','$'
    let1    DB '1: sumar','$'
    let2    DB '2: restar','$'
    let3    DB '3: salir','$'
    dato    DB (0)                ;variable auxiliar para realizar la resta
Sdatos ENDS

Scodigo SEGMENT 'CODE'
              Assume     ss:Spila, ds:Sdatos, cs:Scodigo

    ;procedimiento que imprime un enter
espacp PROC
              mov        ah, 09h
              mov        dx, offset espacio
              int        21h
              ret
espacp ENDP

    ;procedimiento que lanza la interrupcion para saber si esta conectado el ratón
conectado proc
              mov        ax,0
              int        33h
              ret
conectado endp

    ;procedimiento que limpia la pantalla
limpiar proc
              mov        ah, 0
    ;bh para asignar color a la pantalla bh, 00 el primer dígito es para el fondo y el segundo para el color de la letra
              mov        cx,00h
              mov        dx, 184fh
              mov        al, 3
              int        10h
              ret
limpiar endp

    ;macro para mostrar cursor
mostrar proc
              mov        ax,1
              int        33h
              ret
mostrar endp

    ;macro que lee un dato
leer macro
                       mov        ah,01h
                       int        21h
endm

    ;procedimiento que realiza una suma
sumar proc
              call       limpiar
              leer
              call       espacp
              mov        dato,al
              leer
              call       espacp
              add        al,dato                            ;suma los numeros
              sub        al,30h                             ;convierte a caracter
              ret
sumar endp

    ;procedimiento que realiza una resta
restar proc
              call       limpiar
              leer
              call       espacp
              mov        dato, al
              leer
              call       espacp
              sub        dato,al
              add        dato,30h
              ret
restar endp

Main PROC FAR
              push       ds
              push       0
              mov        ax, sdatos
              mov        ds,ax

              call       limpiar
    menu:     
              posicionar 6, 15
              escribir   titulo
              posicionar 8, 15
              escribir   let1
              posicionar 10, 15
              escribir   let2
              posicionar 12, 15
              escribir   let3

    ;ejecutamos el procedimiento que lanza la interrupción para detectar si hay mouse conectado
              call       conectado
    ;en caso de que no haya saltará a presalida
              cmp        ax,0
              je         presalida
    ;en caso contrario lanzamos la interrupción para mostrar el mouse
              call       mostrar

    ;ciclo while que evaluará que opción se ha seleccionado
    while:    
    ;lanzamos interrupción que cacha las coordenadas
              mov        ax,3
              int        33h
    ;evaluamos que se haya oprimido el clic izquierdo
              test       bx,1
              jne        oprimido
              jmp        while
    oprimido: 
    ;calculamos la coordenada en y para saber que linea se ha seleccionado
              mov        ax,dx
              mov        bl,8
              div        bl

    ;evaluamos que linea se ha seleccionado, para saltar a la etiqueta correspondiente
    ;en caso de que no se haya seleccionado alguna fila donde se encuentre una opción, volverá a while
              cmp        al,8
              je         suma
              cmp        al,10
              je         resta
              cmp        al, 12
              je         presalir
              jmp        while

    ;se encuentra en la fila de suma, ahora evaluamos que se encuentre en el rango donde se encuentra el texto
    suma:     
              calCoord   cx
    ;si es menor que 15 no esta dentro del rango y salta a while
              cmp        al,14
              jbe        while
    ;si es mayor que 22 salta a while
              cmp        al,23
              jae        while
    ;si paso esta instrucción indica que esta dentro del rango y llama a sumar
              call       sumar
    ;imprime el resultado
              imprimir   al
    ;salta a menú para mostrarlo nuevamente
              jmp        menu

    ;saltos intermedios por la extensión del código
              jmp        next
    presalida:
              jmp        salida
    prewhile: 
              jmp        while
    presalir: 
              jmp        salir
    next:     

    ;el click se dio en la fila donde se encuentra la opcion de resta, evaluamos que se encuentre en el rango al igual que suma
    resta:    
              calCoord   cx
              cmp        al,14
              jbe        while
              cmp        al,23
              jae        while
    ;se encuentra dentro del rango y llama al procedimiento restar
              call       restar
    ;imprime dato donde se encuentra el resultado
              imprimir   dato
    ;vuelve a menu para mostrarlo una vez mas
              jmp        menu

    ;el click se dio en la fila donde se encuentra la opcion de salir, evaluamos que se encuentre en el rango
    salir:    
              calCoord   cx
              cmp        al,14
              jbe        prewhile
              cmp        al,23
              jae        prewhile
    ;se encuentra dentro del rango por lo tanto salta a salida
              jmp        salida

    salida:   
              call       limpiar
              MOV        AX, 4C00H                          ;que devuelve el control al DOS.
              INT        21H
              call       mostrar
              ret
Main ENDP


Scodigo ENDS
END main