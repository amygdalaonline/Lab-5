# MaxVal.s
#   gcc -no-pie MaxVal.s -o max
#   ./max

    .section .data
Numbers:
    .long 1, 15, 4, 2, 7, 9, 23, 7, 3, 11
Array_length:
    .long 10
MaxValue:
    .long 0
fmt:
    .string "Max value = %d\n"

    .section .text
    .globl main
    .extern printf

main:
    pushq %rbp
    movq  %rsp, %rbp
    subq  $16, %rsp

    movl  Numbers(%rip), %eax      # max = Numbers[0]
    movl  %eax, -8(%rbp)

    movl  $1, -4(%rbp)             # i = 1

.Lcheck:
    movl  -4(%rbp), %eax
    cmpl  Array_length(%rip), %eax
    jge   .Ldone

    movl  -4(%rbp), %eax
    cltq
    movl  Numbers(,%rax,4), %edx   # edx = Numbers[i]

    cmpl  -8(%rbp), %edx
    jle   .Lnext
    movl  %edx, -8(%rbp)           # max = Numbers[i]

.Lnext:
    addl  $1, -4(%rbp)             # i++
    jmp   .Lcheck

.Ldone:
    movl  -8(%rbp), %eax
    movl  %eax, MaxValue(%rip)

    # printf("Max value = %d\n", MaxValue);
    movl  MaxValue(%rip), %esi
    leaq  fmt(%rip), %rdi
    movl  $0, %eax                 # required for variadic functions
    call  printf

    movl  $0, %eax
    leave
    ret

.section .note.GNU-stack,"",@progbits
