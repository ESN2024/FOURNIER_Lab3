#include <stdio.h>
#include "system.h"
#include <io.h>
#include <alt_types.h>
#include "sys/alt_sys_init.h"
#include "opencores_i2c.h"


__uint8_t device, reg, data, datax0=0,datay0=0,dataz0=0, datax1=0,datay1=0,dataz1=0;


void READ_DATA (__uint8_t device, __uint8_t reg,__uint8_t *data ){
    I2C_start(OPENCORES_I2C_0_BASE, device, 0);
    I2C_write(OPENCORES_I2C_0_BASE, reg, 0); // set command to read input register.
    I2C_start(OPENCORES_I2C_0_BASE, device, 1);
    *data = I2C_read(OPENCORES_I2C_0_BASE, 1); // Use 1 as the argument to indicate a NACK on the last read
}

unsigned int READ_XYZ (__uint8_t device,__uint8_t *X0,__uint8_t *X1,__uint8_t *Y0,__uint8_t *Y1, __uint8_t *Z0, __uint8_t *Z1 ){
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

void WRITE_DATA(__uint8_t device, __uint8_t reg, __uint8_t data) {
    I2C_start(OPENCORES_I2C_0_BASE, device, 0);
    I2C_write(OPENCORES_I2C_0_BASE, reg, 0); // set command to write to register
    I2C_write(OPENCORES_I2C_0_BASE, data, 1); // write the data and generate STOP condition
}


int main()
{
    //offset X=3 Y=6 Z=6
    // most devices work at 100Khz  some faster
    I2C_init(OPENCORES_I2C_0_BASE, 50000000, 400000);
   
        // Boucle principale
        device = 0x1D;
        reg = 0x20;
        __int8_t dataW =0;
        WRITE_DATA(device,reg,dataW);
       

        READ_DATA(device,reg,&data);
                usleep(1000000);

        alt_printf("%x \n",data);

 while (1)
    {

        READ_XYZ(device,&datax0,&datax1,&datay0,&datay1,&dataz0,&dataz1);
        alt_printf("x : %x%x; y : %x%x; z : %x%x;\n",datax1,datax0,datay1,datay0,dataz1,dataz0);
        //alt_printf("Data at address 0x%x: 0x%x\n", reg, data);
        usleep(1000000);
    }
    return 0;
}
