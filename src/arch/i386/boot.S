// DEFS
#define ASM_FILE 1
#define STACK_SIZE 0x4000
#define EXT_C(sym) sym
#define AOUT_KLUDGE 0
#define MULTIBOOT_HEADER_FLAGS MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO | MULTIBOOT_VIDEO_MODE | AOUT_KLUDGE

// INCLUDES
#include <multiboot.h>
        
.text
.globl  start, _start
.comm   stack, STACK_SIZE

start:
_start:
   jmp multiboot_entry
   .align  4
        
multiboot_header:
   .long MULTIBOOT_HEADER_MAGIC
   .long MULTIBOOT_HEADER_FLAGS
   .long -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)
   .long 0
   .long 0
   .long 0
   .long 0
   .long 0       
   .long 0
   .long 1024
   .long 768
   .long 32

multiboot_entry:
   movl    $(stack + STACK_SIZE), %esp
   pushl   $0
   popf

   pushl   %ebx
   pushl   %eax

   xor %ebp, %ebp

   call EXT_C(kernel_main)

   call halt

halt:
   hlt
   jmp halt