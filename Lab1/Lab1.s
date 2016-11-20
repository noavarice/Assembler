.text
sys_write     = 4
stdout        = 1
greater_than:
    .string   "Difference between min and max is more than diff!\n"
    .set      g_len,          .-greater_than
non_greater_than:
    .string   "Difference between min and max is not more than diff!\n"
    .set      ng_len,         .-non_greater_than
numbers:
    .long     9, 1, 2, 3, 4, 5, 30, 7, 8, 31
numbers_count:
    .long     10
diff:
    .long     29 
.globl        main

main:
    movl      $numbers,         %eax    #сохраняем в регистре адрес начала массива
    movl      numbers,          %ebx    #минимум будем хранить в регистре %ebx
    movl      numbers,          %edx    #максимум - в edx
    xorl      $1,               %ecx    #счетчик ставим на единицу, так как первое число уже прочитано
start_loop:
    addl      $4,               %eax    #сдвигаем eax на следующий элемент массива
    cmpl      %edx,             (%eax)  #сравниваем этот новый элемент с текущим максимумом
    jle        lesser_or_equal          #если новое число меньше или равно максимуму, его не надо переприсваивать
    movl      (%eax),           %edx
lesser_or_equal:
    cmpl      %ebx,             (%eax)
    jge       greater_or_equal          #если же это число не больше максимума, оно все ещё может быть меньше минимума
    movl      (%eax),           %ebx
greater_or_equal:
    incl      %ecx                      #увеличиваем счетчик и затем проверяем на конец массива
    cmpl      numbers_count,    %ecx
    jl        start_loop
    subl      %ebx,             %edx    #находим разницу между найденными минимумом и максимумом
    movl      $sys_write,       %eax    #заносим в eax номер систменого вызова функции write
    movl      $stdout,          %ebx    #в ebx - номер потока вывода stdout
    cmpl      diff,             %edx    #сравниваем заданную разницу с полученной
    jg        got_diff_more             #в зависимости от результата сравнения выводим то или иное сообщение
    movl      $non_greater_than,%ecx    #в регистр ecx заносим строку, которую будем распечатывать
    movl      $ng_len,          %edx    #в edx - длину этой строки
    int       $0x80                     #и вызываем прерывание
    ret

got_diff_more:
    movl      $greater_than,    %ecx
    movl      $g_len,           %edx
    int       $0x80
    ret
