#ifndef __IRQ_H__
#define __IRQ_H__

#include <kernel/isr.h>

extern void _irq0();
extern void _irq1();
extern void _irq2();
extern void _irq3();
extern void _irq4();
extern void _irq5();
extern void _irq6();
extern void _irq7();
extern void _irq8();
extern void _irq9();
extern void _irq10();
extern void _irq11();
extern void _irq12();
extern void _irq13();
extern void _irq14();
extern void _irq15();

int init_irq();

void irq_install_handler(int32_t irq, void (*handler)(register_t *r));

#endif // !__IRQ_H__