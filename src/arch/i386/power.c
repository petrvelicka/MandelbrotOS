#include <kernel/power.h>
#include <stdint.h>
#include <hw.h>

void reboot()
{
   uint8_t good = 0x02;
   while (good & 0x02)
      good = inb(0x64);
   outb(0x64, 0xFE);
   __asm__("hlt");
}