/*
Sudarykite kalkuliatoriaus programa C kalba mikrovaldikliui PIC16F887, kuri 
sumuotu du skaicius ir sumuojamus skaicius bei atsakyma atvaizduotu LCD ekrane. 
Maksimalus sumuojamas skaicius 255. Skaiciu ivedimui panaudokite EasyPIC 6 
stende esancia klaviatura 4x4.
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

unsigned short 
  kp,
  wasStage = 1,
  stage = 1,
  x = 0, 
  y = 0, 
  sum = 0,
  val;
char txt[3];

// function prototypes
void LCD_move_cursor();
void LCD_inputs_reset();
void LCD_sum_reset();

void main() {
  Keypad_Init(); // keypad init
  ANSEL  = 0; // make I/O digital
  ANSELH = 0;

  // LCD setup
  Lcd_Init();
  Lcd_Cmd(_LCD_CLEAR);
  Lcd_Out(2,1,"y = ");
  Lcd_Out(3,1,"x+y = ");
  Lcd_Out(1,1,"x = ");
  
  while (1) {
    kp = 0; // reset key press variable

    // wait for keypress
    while (!kp) {
      kp = Keypad_Key_Click();
    }

    // interpret the keypress
    switch (kp) {
      case  1: kp = 49; val = 1; break; // 1
      case  2: kp = 50; val = 2; break; // 2
      case  3: kp = 51; val = 3; break; // 3
      case  4: kp = 65; continue; break; // A
      case  5: kp = 52; val = 4; break; // 4
      case  6: kp = 53; val = 5; break; // 5
      case  7: kp = 54; val = 6; break; // 6
      case  8: kp = 66; continue; break; // B
      case  9: kp = 55; val = 7; break; // 7
      case 10: kp = 56; val = 8; break; // 8
      case 11: kp = 57; val = 9; break; // 9
      case 12: kp = 67; continue; break; // C
      case 13: kp = 42; continue; break; // *
      case 14: kp = 48; val = 0; break; // 0
      case 15: kp = 35; val = 0; break; // #
      case 16: kp = 68; continue; break; // D
    }

    if (kp == 35) { // if # then next stage
      stage++;
      LCD_move_cursor();
    } else {
      if (kp > 47 && kp < 58) { // if number pressed then write it down
        Lcd_Chr_CP(kp);
      }
    }
    
    // update values
    switch (stage) {
      case 1: // x input stage
        x = x * 10 + val;
        break;
      case 2: // y input stage
        y = y * 10 + val;
        break;
      case 3: // calculation stage
        LCD_sum_reset();
        LCD_move_cursor();
        WordToStr(x + y, txt);
        Lcd_Out_CP(txt);
        x = 0;
        y = 0;
        stage = 1;
        LCD_inputs_reset();
        LCD_move_cursor();
        break;
    }
  }
}

void LCD_move_cursor(){
  switch (stage) {
    case 1: Lcd_Chr(1,4,32); break;
    case 2: Lcd_Chr(2,4,32); break;
    case 3: Lcd_Chr(3,6,32); break;
  }
}

void LCD_inputs_reset(){
  Lcd_Out(1,4,"     ");
  Lcd_Out(2,4,"     ");
}

void LCD_sum_reset(){
  Lcd_Out(3,6,"     ");
}