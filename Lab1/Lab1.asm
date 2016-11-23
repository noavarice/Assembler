section         .text
global          main
main:
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
hello           db              'Hello, world!', 0xa
len             equ             $-hello
