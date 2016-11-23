section         .text
global          main
main:
        mov     eax,            numbers
        mov     bl,             [numbers]
        mov     dl,             [numbers]
        mov     cl,             1
loop:
        inc     eax
        cmp     [eax],          bl
        jge     if_not_minimum
        mov     bl,             [eax]
        jmp     back_to_loop
if_not_minimum:
        cmp     [eax],          dl
        jle     back_to_loop
        mov     dl,             [eax]
back_to_loop:
        inc     cl
        cmp     cl,             numbers_count
        jl      loop
        sub     dl,             bl
        cmp     dl,             diff
        je      ur_right
        mov     eax,            sys_exit
        int     0x80

ur_right:
        mov     eax,            sys_write
        mov     ebx,            stdout
        mov     ecx,            hello
        mov     edx,            len
        int     0x80
        mov     eax,            sys_exit
        int     0x80

section         .data
sys_write       equ             4
sys_exit        equ             1
stdout          equ             1
hello           db              'You are right!', 0xa
len             equ             $-hello
numbers         db              9, 1, 2, 3, 4, 5, 6, 7, 8, 11
numbers_count   equ             10
diff            equ             1
