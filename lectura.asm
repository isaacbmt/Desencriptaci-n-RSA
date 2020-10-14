global _main

    ;extern StrToIntA
    ;extern _ReadFile
    extern _ExitProcess@4
    extern _OpenFile@12
    extern _WriteFile@20
    extern _CloseHandle@4
    extern _printf
    extern _atoi
    
    ;import StrToIntA kernel32.dll
    ;import ExitProcess kernel32.dll
    ;import printf msvcrt.dll
    ;import atoi msvcrt.dll
    ;; extern _printf
    ;; extern _atoi
    ;; extern _fopen
    ;; extern _fclose

    section .data
    imgname     db 'imagen.txt', 0
    
    enc_img:
    incbin '0.txt', 0
    enc_img_end    db 0
    
    section .bss
    num1 resd 100
    num2 resb 100
    
    section .text
    
_main:
    mov ebp, esp; for correct debugging
    
    xor edx, edx
    mov eax, 321
    mov ebx, 10
    div ebx
    
    push eax
    push format
    call _printf
    add esp, 8
    
    ;call calc
    push dword 0
    call _ExitProcess@4
calc:
    push ebx
    push esi
    push edi

    mov ebx, [dword esp + 24]         ;puntero a los valores de la llave

    ;push dword [ebx + 4]      ;valor de 'd'
    ;call _atoi
    ;add esp, 4
    ;mov esi, eax
    ;add eax, 48
    
    ;lea ecx, [num1]
    mov ecx, [ebx + 4]
    mov [num1], ecx
    
    ;mov esi, [num1]
    ;add esi, 48
    mov edx, 32
    mov [num1 + 1], edx
    ;push  dword [ebx + 8]       ;valor de 'e'
    ;call _atoi
    ;add esp, 4
    mov edi, [ebx + 8]
    mov [num1 + 2], edi
    ;push edi
    
    ;add edi, 48
    
    push ecx
    push format
    call _printf
    add esp, 8
    ;pop edi
    ;mov edi, [num2]
    ;mov eax, esi
    ;mov edx, 0 
    ;idiv [num2]              ;prueba suma d + e


    lea ebx, [ebp - 148]
    push dword 1 | 0x1000
    push ebx
    push dword filename
    call _OpenFile@12
    mov dword [ebp - 4], eax

    lea ebx, [ebp - 8]
    push dword 0
    push ebx
    push dword 10
    push dword num1
    push dword [ebp - 4]
    call _WriteFile@20
    
    push dword [ebp - 4]
    call _CloseHandle@4

    pop edi
    pop esi
    pop ebx
    ret


filename db 'isaac3000.txt', 0

format:
   db '%d', 10, 0
    
write:
    db 'w'
