#line 1 "C:/Program Files/mikroC PRO for PIC/HW1.c"
#line 8 "C:/Program Files/mikroC PRO for PIC/HW1.c"
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


char keypadPort at PORTD;

unsigned short kp, col = 1, row = 1;

void main() {
 Keypad_Init();
 ANSEL = 0;
 ANSELH = 0;


 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 while (1) {
 kp = 0;


 while (!kp) {
 kp = Keypad_Key_Click();
 }


 switch (kp) {
 case 1: kp = 49; break;
 case 2: kp = 50; break;
 case 3: kp = 51; break;
 case 4: kp = 65; break;
 case 5: kp = 52; break;
 case 6: kp = 53; break;
 case 7: kp = 54; break;
 case 8: kp = 66; break;
 case 9: kp = 55; break;
 case 10: kp = 56; break;
 case 11: kp = 57; break;
 case 12: kp = 67; break;
 case 13: kp = 42; break;
 case 14: kp = 48; break;
 case 15: kp = 35; break;
 case 16: kp = 68; break;
 }

 Lcd_Chr(row, col, kp);


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
