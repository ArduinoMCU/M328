#define F_CPU 16000000UL    

#include <avr/io.h>
#include <util/delay.h>
#include <avrbasics.h>

int main(void) {
    PORTB = 0xFF;   // Set as output
    while (True) {
        PORTB = 0x00;   // Set as low
        _delay_ms(1000);
        PORTB = 0xFF;   // Set as high
        _delay_ms(1000);
    }

    return 0;
}