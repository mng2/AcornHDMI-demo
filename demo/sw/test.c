// test non-fp methods for converting XADC raw values

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

void ezfloat(uint32_t, char*);
void ezfloat2(uint32_t, char*);

int
main(void)
{
    uint32_t val = 0x0000996c;
    char f[] = "0.000";
    ezfloat(val, f);
    printf("hullo %s\n", f);
    val = 0x0000b5f0;
    char t[] = "000.0";
    ezfloat2(val, t);
    printf("hallo %s\n", t);
    return 0;
    
}

void
ezfloat(uint32_t v, char *s)
{
    //xadc voltages: 3V = full scale = 65536
    //so 1V ~= 21845
    const uint32_t factor = 21845;
    uint32_t r;
    char *p = s;
    p[0] = (char)((v / factor) + '0');
    r = v % factor * 10;
    p[2] = (char)((r / factor) + '0');
    r = r % factor * 10;
    p[3] = (char)((r / factor) + '0');
    r = r % factor * 10;
    p[4] = (char)((r / factor) + '0');
}

// tempC = code*503.975/scale - 273.15
// thous = code*503975/scale - 273150
// scale*thous = code*503975 - 273150*scale
// negative degC not supported!
void
ezfloat2(uint32_t v, char *s)
{
    const uint64_t kelvin = 273150;
    const uint64_t fullscale = 1 << 16;
    char *p = s;
    uint64_t temp, place;
    temp = ((uint64_t)v)*503975 - kelvin*fullscale;
    place = temp/fullscale/1000/100;
    if (place) {
        p[0] = (char)(place) + '0';
    } else {
        p[0] = ' ';
    }
    temp = temp % (fullscale*1000*100);
    place = temp/fullscale/1000/10;
    p[1] = (char)(place) + '0';
    temp = temp % (fullscale*1000*10);
    place = temp/fullscale/1000;
    p[2] = (char)(place) + '0';
    temp = temp % (fullscale*1000);
    place = temp/fullscale/100;
    p[4] = (char)(place) + '0';
}
