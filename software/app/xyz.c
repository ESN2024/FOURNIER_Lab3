#include <stdio.h>
#include <stdint.h>
#include "system.h"
#include <io.h>
#include <alt_types.h>
#include "sys/alt_sys_init.h"
#include "opencores_i2c.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_timer.h"
#include "sys/alt_irq.h"

volatile int axe = 0, negatifX = 0, negatifY = 0, negatifZ = 0;

volatile int16_t X, Y, Z;

volatile __uint8_t device, datax0 = 0, datay0 = 0, dataz0 = 0, datax1 = 0, datay1 = 0, dataz1 = 0;

void READ_DATA(__uint8_t device, __uint8_t reg, __uint8_t *data)
{
    I2C_start(OPENCORES_I2C_0_BASE, device, 0);
    I2C_write(OPENCORES_I2C_0_BASE, reg, 0); // set command to read input register.
    I2C_start(OPENCORES_I2C_0_BASE, device, 1);
    *data = I2C_read(OPENCORES_I2C_0_BASE, 1); // Use 1 as the argument to indicate a NACK on the last read
    alt_printf("0x%x\n", *data);
}

unsigned int READ_XYZ(__uint8_t device, __uint8_t *X0, __uint8_t *X1, __uint8_t *Y0, __uint8_t *Y1, __uint8_t *Z0, __uint8_t *Z1)
{
    I2C_start(OPENCORES_I2C_0_BASE, device, 0);
    I2C_write(OPENCORES_I2C_0_BASE, 0x32, 0); // set command to read input register.
    I2C_start(OPENCORES_I2C_0_BASE, device, 1);
    *X0 = I2C_read(OPENCORES_I2C_0_BASE, 1); // Use 1 as the argument to indicate a NACK on the last read

    I2C_start(OPENCORES_I2C_0_BASE, device, 0);
    I2C_write(OPENCORES_I2C_0_BASE, 0x33, 0); // set command to read input register.
    I2C_start(OPENCORES_I2C_0_BASE, device, 1);
    *X1 = I2C_read(OPENCORES_I2C_0_BASE, 1); // Use 1 as the argument to indicate a NACK on the last read

    I2C_start(OPENCORES_I2C_0_BASE, device, 0);
    I2C_write(OPENCORES_I2C_0_BASE, 0x34, 0); // set command to read input register.
    I2C_start(OPENCORES_I2C_0_BASE, device, 1);
    *Y0 = I2C_read(OPENCORES_I2C_0_BASE, 1); // Use 1 as the argument to indicate a NACK on the last read

    I2C_start(OPENCORES_I2C_0_BASE, device, 0);
    I2C_write(OPENCORES_I2C_0_BASE, 0x35, 0); // set command to read input register.
    I2C_start(OPENCORES_I2C_0_BASE, device, 1);
    *Y1 = I2C_read(OPENCORES_I2C_0_BASE, 1); // Use 1 as the argument to indicate a NACK on the last read

    I2C_start(OPENCORES_I2C_0_BASE, device, 0);
    I2C_write(OPENCORES_I2C_0_BASE, 0x36, 0); // set command to read input register.
    I2C_start(OPENCORES_I2C_0_BASE, device, 1);
    *Z0 = I2C_read(OPENCORES_I2C_0_BASE, 1); // Use 1 as the argument to indicate a NACK on the last read

    I2C_start(OPENCORES_I2C_0_BASE, device, 0);
    I2C_write(OPENCORES_I2C_0_BASE, 0x37, 0); // set command to read input register.
    I2C_start(OPENCORES_I2C_0_BASE, device, 1);
    *Z1 = I2C_read(OPENCORES_I2C_0_BASE, 1); // Use 1 as the argument to indicate a NACK on the last read
}

void WRITE_DATA(__uint8_t device, __uint8_t reg, __uint8_t data)
{
    I2C_start(OPENCORES_I2C_0_BASE, device, 0);
    I2C_write(OPENCORES_I2C_0_BASE, reg, 0);    // set command to write to register
    I2C_write(OPENCORES_I2C_0_BASE, data, 1);   // write the data and generate STOP condition
}

static void timer_irqhandler(void *context, alt_u32 id)
{
    READ_XYZ(device, &datax0, &datax1, &datay0, &datay1, &dataz0, &dataz1);

    X = (datax1 << 8) + datax0;
    Y = (datay1 << 8) + datay0;
    Z = (dataz1 << 8) + dataz0;

    // Complément à deux
    if (X & 0x8000)
    {
        X = ~X + 1;
        negatifX = 1;
    }
    else
    {
        negatifX = 0;
    }

    if (Y & 0x8000)
    {
        Y = ~Y + 1;
        negatifY = 1;
    }
    else
    {
        negatifY = 0;
    }

    if (Z & 0x8000)
    {
        Z = ~Z + 1;
        negatifZ = 1;
    }
    else
    {
        negatifZ = 0;
    }

    // Multiplication par 3.9 (en utilisant des entiers, donc * 39 / 10)
    X = (__int16_t)(X * 39 / 10);
    Y = (__int16_t)(Y * 39 / 10);
    Z = (__int16_t)(Z * 39 / 10);

    alt_printf("x : %x; y : %x; z : %x;\n", X, Y, Z);

    if (axe == 0)
    {
        display_segment(X, negatifX);
    }
    if (axe == 1)
    {
        display_segment(Y, negatifY);
    }
    if (axe == 2)
    {
        display_segment(Z, negatifZ);
    }

    IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_0_BASE, 0x1);
}

void display_segment(int16_t X, int negatif)
{
    __uint8_t d1, d2, d3, d4;

    // Calcul BCD d'un nombre de 4 chiffres
    d1 = (X / 1000) % 10; // Milliers
    d2 = (X / 100) % 10;  // Centaines
    d3 = (X / 10) % 10;   // Dizaines
    d4 = X % 10;          // Unités

    if (negatif)
    {
        IOWR_ALTERA_AVALON_PIO_DATA(PIO_4_BASE, 0b1011); // Met le signe - car dans le .vhdl on initialise - avec 0b1111
    }
    else
    {
        IOWR_ALTERA_AVALON_PIO_DATA(PIO_4_BASE, 0b1111); // Affiche 0 (signe +)
    }

    IOWR_ALTERA_AVALON_PIO_DATA(PIO_0_BASE, d4); // Affiche l'unité sur le digit0
    IOWR_ALTERA_AVALON_PIO_DATA(PIO_1_BASE, d3); // Affiche les dizaines sur le digit1
    IOWR_ALTERA_AVALON_PIO_DATA(PIO_2_BASE, d2); // Affiche les centaines sur le digit2
    IOWR_ALTERA_AVALON_PIO_DATA(PIO_3_BASE, d1); // Affiche les millièmes sur le digit3
}

static void bp_irqhandler(void *context, alt_u32 id)
{
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_5_BASE, 0x1);

    if (axe > 2)
    {
        axe = 0;
    }
    else
    {
        axe++;
    }
    alt_printf("bouton (0=X;1=Y;2=Z) : %x \n", axe);
}

int main()
{
    axe = 0;
    IOWR_ALTERA_AVALON_PIO_IRQ_MASK(PIO_5_BASE, 0x1);
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_5_BASE, 0x1);

    alt_irq_register(TIMER_0_IRQ, NULL, timer_irqhandler);
    alt_irq_register(PIO_5_IRQ, NULL, bp_irqhandler);

    // Most devices work at 100Khz; some are faster
    I2C_init(OPENCORES_I2C_0_BASE, 50000000, 400000);

    device = 0x1D;
    WRITE_DATA(device, 0x31, 0X8);
    READ_DATA(device, 0x31, &datax0);
    WRITE_DATA(device, 0x1E, 2);
    WRITE_DATA(device, 0x1F, 5);
    WRITE_DATA(device, 0x20, 0);

    while (1)
    {
    }
    return 0;
}
