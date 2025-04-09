#define F_CPU 16000000UL 

#include <avr/io.h>
#include <util/delay.h>

int main(void) {
    // Set PORTB0 as output
    DDRB |= (1 << DDB0);
    
    while (1) {
        // Toggle PORTB0
        PORTB ^= (1 << PORTB0);
        
        // Wait for 500 milliseconds
        _delay_ms(500);
    }
    
    return 0;
}