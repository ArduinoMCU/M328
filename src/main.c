#define F_CPU 16000000UL

#include <avr/io.h> 
#include <util/delay.h>

int main() {
    DDRB |= (1 << DDB5); // Set pin 13 as output
    while (1) {
        PORTB ^= (1 << PORTB5); // Toggle pin 13
        _delay_ms(1000); // Delay 1 second
    }
    return 0;
}