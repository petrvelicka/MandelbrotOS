ARCH=i386

CC=cross/bin/$(ARCH)-elf-gcc
LD=cross/bin/$(ARCH)-elf-ld

AS=nasm
QEMU=qemu-system-x86_64 --cdrom mandelbrotos.iso
LIBGCC=cross/lib/gcc/$(ARCH)-elf/8.2.0/libgcc.a

CWARNINGS= -Wno-unused-variable -Wno-attributes -Wno-unused-parameter -Wno-pointer-to-int-cast -Wno-int-conversion
CFLAGS=-m32 -std=c99 -nostdlib -nostartfiles -nodefaultlibs -ffreestanding -fno-builtin -fno-omit-frame-pointer $(CWARNINGS) $(CINCLUDES) -Isrc/include/
DFLAGS=-g -DDEBUG -O0

ASFLAGS=-f elf

LDFLAGS=-melf_i386 -nostdlib -T src/arch/$(ARCH)/linker.ld -Map=mandelbrotos.map 

CSOURCES:=\
src/kernel/kernel.c\
src/kernel/pit.c\
src/kernel/text.c\
src/kernel/init.c\
src/kernel/kbd.c\
src/kernel/alloc.c\
src/kernel/kpanic.c\
src/kernel/kshell.c\
src/string/string.c\
src/arch/$(ARCH)/gdt.c\
src/arch/$(ARCH)/idt.c\
src/arch/$(ARCH)/isr.c\
src/arch/$(ARCH)/irq.c\
src/arch/$(ARCH)/vbe.c\
src/arch/$(ARCH)/hw.c\
src/arch/$(ARCH)/cpuid.c\
src/arch/$(ARCH)/power.c\

ASOURCES:=\
src/arch/$(ARCH)/boot.S\

NASMSOURCES:=\
src/arch/$(ARCH)/interrupts.asm\

COBJECTS:=$(CSOURCES:%.c=%.o)
AOBJECTS:=$(ASOURCES:%.S=%.ao)
NASMOBJECTS:=$(NASMSOURCES:%.asm=%.aso)

OBJS=\
$(ARCH_OBJS)\
$(KERNEL_OBJS)\

KERNEL=mandelbrotos.elf

STAGE2=build/stage2_eltorito
GENISOIMAGE=genisoimage

ISO=mandelbrotos.iso

all: build qemu

build: $(KERNEL)
	mkdir -p iso/boot/grub
	cp $(KERNEL) iso/boot/$(KERNEL)
	cp resources/grub.cfg iso/boot/grub
	grub-mkrescue -o $(ISO) iso

$(KERNEL): $(CSOURCES) $(ASOURCES) $(NASMSOURCES) $(COBJECTS) $(AOBJECTS) $(NASMOBJECTS)
	$(LD) $(LDFLAGS) $(AOBJECTS) $(COBJECTS) $(NASMOBJECTS) $(LIBGCC) -o $@

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

%.ao: %.S
	$(CC) $(CFLAGS) -o $@ -c $<

%.aso: %.asm
	$(AS) $(ASFLAGS) -o $@ $<

qemu:
	$(QEMU)

clean:
	rm -f mandelbrotos.elf
	rm -f mandelbrotos.map
	rm -f *.o */*.o */*/*.o */*/*/*.o
	rm -f *.ao */*.ao */*/*.ao */*/*/*.ao
	rm -f *.aso */*.aso */*/*.aso */*/*/*.aso
	rm -f *.d */*.d */*/*.d

clean-iso:
	rm -f mandelbrotos.elf
	rm -f mandelbrotos.map
	rm -f mandelbrotos.iso
	rm -f *.o */*.o */*/*.o */*/*/*.o
	rm -f *.ao */*.ao */*/*.ao */*/*/*.ao
	rm -f *.aso */*.aso */*/*.aso */*/*/*.aso
	rm -f *.d */*.d */*/*.d
