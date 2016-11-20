.text
.data
#------------------------------
#константы
sys_read          =           3
sys_write         =           4
stdin             =           0
stdout            =           1
ascii_zero_code   =           48
max_string_length =           10
int_size          =           4
max_numbers_count =           10
max_buffer_size   =           10
diff              =           5
#-----------------------------
.lcomm          numbers,      int_size * max_numbers_count
.lcomm          buffer,       max_buffer_size

get_count:      .string       "Input numbers count (it will be 10 if you input more than 10): "
.set            gc_len,       .-get_count
get_numbers:    .string       "Type numbers and then input them by pressing enter:\n"
.set            gn_len ,      .-get_numbers
you_are_right:  .string       "You are right"
.set            urr_len,      .-you_are_right
.globl                        main

main:
    call  GetNumbersCount
    movl  %eax,               %esi
    movl  $numbers,           %edi
    call  GetNumbers
    call  HandleNumbers
    cmpl  $diff,              %ebx
    jg    ur_right
    ret
    

GetNumbersCount:
    movl  $sys_write,         %eax
    movl  $stdout,            %ebx
    movl  $get_count,         %ecx
    movl  $gc_len,            %edx
    int   $0x80

    movl  $sys_read,          %eax
    movl  $stdout,            %ebx
    movl  $buffer,            %ecx
    movl  $max_buffer_size,   %edx
    int   $0x80

    push  buffer
    call  StrToInt
    pop   buffer

    cmpl  $10,                %eax
    jl    return
    movl  $10,                %eax
return:
    ret


GetNumbers:
    movl  $sys_write,         %eax
    movl  $stdout,            %ebx
    movl  $get_numbers,       %ecx
    movl  $gn_len,            %edx
    int   $0x80

    push  %rsi
    push  %rdi

get_all_numbers:
    movl  $sys_read,          %eax
    movl  $stdout,            %ebx
    movl  $buffer,            %ecx
    movl  $max_buffer_size,   %edx
    int   $0x80

    push  buffer
    call  StrToInt
    pop   buffer

    movl  %eax,               (%edi)
    addl  $int_size,          %edi
    decl  %esi
    cmpl  $0,                 %esi
    jg    get_all_numbers

    pop   %rdi
    pop   %rsi

    ret

StrToInt:
    push  %rbx
    mov   %rsp,               %rbx
    add   $0x10,              %rbx
    mov   (%rbx),             %rdx
    xor   %rax,               %rax
while_not_0xA:
    imul  $10,                %eax
    add   %dl,                %al
    sub   $ascii_zero_code,   %eax
    shr   $8,                 %rdx
    cmp   $10,                %dl
    jne   while_not_0xA
    pop   %rbx
    ret

HandleNumbers:
    movl  (%edi),             %eax
    movl  (%edi),             %ebx
    decl  %esi
while_not_handle_all_numbers:
    addl  $4,                 %edi
    cmpl  %eax,               (%edi)
    jl    new_minimum
    cmpl  %ebx,               (%edi)
    jg    new_maximum
    jmp   back_to_loop
new_minimum:
    movl  (%edi),             %eax
    jmp   back_to_loop
new_maximum:
    movl  (%edi),             %ebx
back_to_loop:
    decl  %esi
    cmpl  $0,                 %esi
    jg    while_not_handle_all_numbers
    subl  %eax,               %ebx
    ret

ur_right:
    movl  $sys_write,         %eax
    movl  $stdout,            %ebx
    movl  $you_are_right,     %ecx
    movl  $urr_len,           %edx
    int   $0x80
    ret
