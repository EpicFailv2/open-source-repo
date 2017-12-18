/*
Sudarykite programa C kalba mikrovaldikliui PIC16F887, kuri leistu naudojantis 
EasyPIC 6 stende esancia klaviatura 4x4 ikelti i LCD ekranA skaicius nuo 0 iki 9,
raides A,B,C,D ir  ženklus*, #. Programa sudarykite naudodamiesi Mikro C kompiliatoriumi.
*/

// LCD connection
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;

// keypad connection
char keypadPort at PORTD;

unsigned short kp, col = 1, row = 1;

void main() {
  Keypad_Init(); // keypad init
  ANSEL  = 0; // make I/O digital
  ANSELH = 0;

  // LCD setup
  Lcd_Init();
  Lcd_Cmd(_LCD_CLEAR);
  Lcd_Cmd(_LCD_CURSOR_OFF);

  while (1) {
    kp = 0; // reset key press variable
    
    // wait for keypress
    while (!kp) {
      kp = Keypad_Key_Click();
    }
    
    // interpret the keypress
    switch (kp) {
      case  1: kp = 49; break; // 1
      case  2: kp = 50; break; // 2
      case  3: kp = 51; break; // 3
      case  4: kp = 65; break; // A
      case  5: kp = 52; break; // 4
      case  6: kp = 53; break; // 5
      case  7: kp = 54; break; // 6
      case  8: kp = 66; break; // B
      case  9: kp = 55; break; // 7
      case 10: kp = 56; break; // 8
      case 11: kp = 57; break; // 9
      case 12: kp = 67; break; // C
      case 13: kp = 42; break; // *
      case 14: kp = 48; break; // 0
      case 15: kp = 35; break; // #
      case 16: kp = 68; break; // D
    }
    
    Lcd_Chr(row, col, kp); // print it on LCD
    
    // following is playing around
    col++;
    if (col > 14) {
      row++;
      col = 1;
    }
    if (row > 6) {
      row = 1;
    }
  }
}