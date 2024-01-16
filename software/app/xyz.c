#include <stdio.h>
#include "system.h"
#include <io.h>
#include <alt_types.h>
#include "sys/alt_sys_init.h"
#include "opencores_i2c.h"


volatile     __uint8_t device, reg, data=0;


void READ_DATA (__uint8_t device, __uint8_t reg,__uint8_t *data ){
    I2C_start(OPENCORES_I2C_0_BASE, device, 0);
    I2C_write(OPENCORES_I2C_0_BASE, reg, 0); // set command to read input register.
    I2C_start(OPENCORES_I2C_0_BASE, device, 1);
    *data = I2C_read(OPENCORES_I2C_0_BASE, 1); // Use 1 as the argument to indicate a NACK on the last read
}


int main()
{
    // most devices work at 100Khz  some faster
    I2C_init(OPENCORES_I2C_0_BASE, 50000000, 400000);
    while (1)
    {
        // Boucle principale
        device = 0x1D;
        reg = 0x34;
        READ_DATA(device,reg,&data);
        alt_printf("Data at address 0x%x: 0x%x\n", reg, data);
        usleep(1000000);
    }
    return 0;
}
