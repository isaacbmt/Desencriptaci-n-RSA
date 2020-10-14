global _main

    extern _ExitProcess@4
    extern _OpenFile@12
    extern _WriteFile@20
    extern _CloseHandle@4
    extern _printf
    extern _atoi
    
    section .data
    filename    db 'isaac3000.txt', 0
    
    enc_img:
    incbin '0.txt', 0, 30
    enc_img_end    db 0
    
    section .bss
    num_d   resb 10
    num_n   resb 10
    img     resb 1000
    
    section .text
_main:
    mov ebp, esp    ; for correct debugging
    push ebx
    ;mov eax, 3163
    ;mov [num_d], eax
    ;mov eax, 3599
    ;mov [num_n], eax
    call storeNandD ;guarda los argumentos en num_d y num_n

    lea edi, [enc_img]      ;Direccion del primer byte del mensaje encriptado
    lea ebx, [img]          ;Direccion del primer byte de la imagen desencriptada
    mov edx, 0              ;contador que indica si el numero es la parte LSB o MSB
split:
    mov esi, edi            ;Guarda la direccion del primer byte
    lea ecx, [enc_img_end]  ;Guarda la direccion del ultimo byte
    sub ecx, edi            ;Cuantos bytes faltan? si 0 => termina
    jz finish
    
    mov al, ' '     ;Busca el primer espacio en el string
    repne scasb
    mov ecx, edi    ;almacena su direccion en ecx = edi
    dec ecx         ;disminuye 1 para no contar el espacio
    sub ecx, esi    ;largo de la primer palabra

    cmp ecx, 0      ;cuando el primer caracter es un espacio
    jz split

    push ecx        ;guarda los registros
    push ebx
    push edx
    
    xor ebx, ebx    ;Obtiene el siguiente numero para desencriptar en eax
    xor edx, edx
    call getEncNumber
    
    pop edx
    pop ebx         ;restaura el valor de los registros
    pop ecx

    cmp edx, 1      ;edx == 1? descencripta el numero : almacena la LSB en el stack
    jz  LSB
    shl eax, 8      ; eax << 8
    push eax        ;almacena el MSB en el stack
    inc edx         ;aumenta el contador
    jmp split       ;hace la siguiente iteracion
LSB:
    xor edx, edx    ;vuelve a 0
    add eax, [esp]  ; MSB + LSB
    add esp, 4

    push esi        ;guarda los registros en el stack
    push ecx
    push ebx
    
    mov ecx, 1      ;valor inicial del resultado
    mov esi, [num_n];guarda el valor de num_n en un registro
    mov ebx, [num_d]
    div esi
    mov eax, edx    ;guarda eax % esi en un registro
    call modular_pow;hace la operacion: ecx = base ^ num_d % num_n
    
    ; Escribe ecx en la variable
    pop ebx
    
    mov eax, ecx    ;entero a convertir
    mov esi, 10     ;n = 10
    call itoa       ;str(int eax)
    
    push ecx
    push dword format
    call _printf
    add esp, 8
    
    xor edx, edx
    xor eax, eax

    pop ecx     ;restaura el valor de los registros
    pop esi
    
    jmp split       ;hace la siguiente iteracion
    
storeNandD:
    push ebx
    push esi
    push edi

    mov ebx, [dword esp + 28] ;puntero a los valores de la llave

    push dword [ebx + 4]      ;valor de 'd'
    call _atoi
    add esp, 4
    mov [num_d], eax          ;almacena 'd' en una variable

    push dword [ebx + 8]      ;valor de 'n'
    call _atoi
    add esp, 4
    mov [num_n], eax          ;almacena 'n' en una variable

    pop edi
    pop esi
    pop ebx
    ret
getEncNumberloop:     
    mov ebx, eax
getEncNumber:
    dec ecx         ;disminuye el contador
    
    movzx eax, byte [esi + ecx]
    sub eax, 48     ;obtiene el entero del char
    
    cmp edx, 0      ;ecx == 0? no hace la elevacion : calcula (eax * 10 ^ ecx)
    jz getEncNumberAux
    
    push edx        ;guarda los registros
    push ecx
    push eax
    
    push edx        ;10 ^ ecx
    push 10
    call pow
    add esp, 8
    
    imul dword [esp];eax * 10 ^ ecx
    add esp, 4
    pop ecx         ;restaura los registros
    pop edx
getEncNumberAux:
    add eax, ebx    ;le suma el siguiente caracter al numero
    inc edx         ;disminuye el contador
    
    cmp ecx, 0      ;ecx !=  0? hace otra iteracion : retorna
    jnz getEncNumberloop
    ret
pow:
    mov ecx, [esp + 8]
    mov eax, 1          ;numero neutral de la multiplicacion
looppow:
    imul dword [esp + 4];multiplica la base de la potencia a eax
    dec ecx             ;disminuye en 1 el exponente
    cmp ecx, 0          ;ecx != 0? hace otra iteracion : retorna
    jnz looppow
    ret
modular_pow: ;ecx = eax ^ ebx % esi
    push eax
    push esi
    
    mov eax, ebx    ;calcula exp % 2
    mov esi, 2
    call module
    
    pop esi
    pop eax
    
    cmp edx, 1      ;exp % 2 == 1?
    jnz modular_aux
    
    push eax
    mul ecx         ;result * base
    call module     ;result = (result * base) % n
    mov ecx, edx
    pop eax
modular_aux:
    shr ebx, 1      ;exp >> 1

    mul eax         ;base * base
    call module 
    mov eax, edx    ;base = (base * base) % n
    
    cmp ebx, 0
    jg  modular_pow ;exp > 0? hace otra iteracion : retorna result
    xor edx, edx
    ret

itoa:   ;ecx = str(int eax)
    push eax        ;guarda los digitos mayores a 9 en memoria
    mov ecx, 1
    call get_msb
    add eax, 48
    call save_char
    pop eax
    sub eax, ecx    ;num - MSB(num)
    
    cmp eax, 9      ;eax > 9? hace otra iteracion : sigue
    jg  itoa
    
    add eax, 48     ;guarda el digita lsb
    call save_char
    
    mov eax, 32     ;guarda un espacio
    call save_char
    ret
    
get_msb: ;edx = get_masb(eax)
    call division   ;eax = eax // 10
    
    push eax        
    mov eax, ecx   
    mul esi         
    mov ecx, eax    
    pop eax         
    
    cmp eax, 9      ;eax > 9? hace otra iteracion : sigue
    jg  get_msb
    
    push eax
    mov eax, ecx
    call division
    pop eax
    
    mov edx, eax
    mul ecx
    mov ecx, eax
    mov eax, edx
    ret
    
save_char:
    mov [ebx], eax
    inc ebx
    ret
    
module:  ; edx = eax % esi 
    xor edx, edx
    div esi
    ret
division:; eax = eax // esi
    xor edx, edx
    div esi
    ret
write_file:
    ;mov ecx, ebx
    push ebx
    push eax
    
    ;HFILE OpenFile(lpFileName, lpReOpenBuff, uStyle);
    lea ebx, [ebp - 148]    ;La direccion del OFSTRUCT (es una estructura de la libreria)
    push dword 1 | 0x1000   ;Escribir | Crear
    push ebx
    push dword filename     ;nombre del archivo que se va a abrir
    call _OpenFile@12
    mov dword [ebp - 4], eax;guarda el file handle
    
    ;BOOL WriteFile(hFile, lpBuffer, nNumberOfBytesToWrite, lpNumberOfBytesWritten, lpOverlapped);
    sub  ecx, img
    lea ebx, [ebp - 8]      ;Numero de bytes escritos
    push dword 0
    push ebx
    push dword 50                ;Largo del mensaje
    push dword img          ;La direccion del mensaje
    push dword [ebp - 4]    ;El file handle que se va a usar para escribir al archivo
    call _WriteFile@20
    
    push dword [ebp - 4]    ;Cierra el file handle
    call _CloseHandle@4
    pop ebx
    pop eax
    ret
finish:   
    call write_file
    xor eax, eax
    pop ebx
    push dword 0
    call _ExitProcess@4
    ret
        
format:
    db  '%d', 13, 10, 0