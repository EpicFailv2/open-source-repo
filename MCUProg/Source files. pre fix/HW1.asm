
_main:

;HW1.c,27 :: 		void main() {
;HW1.c,28 :: 		Keypad_Init(); // keypad init
	CALL       _Keypad_Init+0
;HW1.c,29 :: 		ANSEL  = 0; // make I/O digital
	CLRF       ANSEL+0
;HW1.c,30 :: 		ANSELH = 0;
	CLRF       ANSELH+0
;HW1.c,33 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;HW1.c,34 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HW1.c,35 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HW1.c,37 :: 		while (1) {
L_main0:
;HW1.c,38 :: 		kp = 0; // reset key press variable
	CLRF       _kp+0
;HW1.c,41 :: 		while (!kp) {
L_main2:
	MOVF       _kp+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main3
;HW1.c,42 :: 		kp = Keypad_Key_Click();
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      _kp+0
;HW1.c,43 :: 		}
	GOTO       L_main2
L_main3:
;HW1.c,46 :: 		switch (kp) {
	GOTO       L_main4
;HW1.c,47 :: 		case  1: kp = 49; break; // 1
L_main6:
	MOVLW      49
	MOVWF      _kp+0
	GOTO       L_main5
;HW1.c,48 :: 		case  2: kp = 50; break; // 2
L_main7:
	MOVLW      50
	MOVWF      _kp+0
	GOTO       L_main5
;HW1.c,49 :: 		case  3: kp = 51; break; // 3
L_main8:
	MOVLW      51
	MOVWF      _kp+0
	GOTO       L_main5
;HW1.c,50 :: 		case  4: kp = 65; break; // A
L_main9:
	MOVLW      65
	MOVWF      _kp+0
	GOTO       L_main5
;HW1.c,51 :: 		case  5: kp = 52; break; // 4
L_main10:
	MOVLW      52
	MOVWF      _kp+0
	GOTO       L_main5
;HW1.c,52 :: 		case  6: kp = 53; break; // 5
L_main11:
	MOVLW      53
	MOVWF      _kp+0
	GOTO       L_main5
;HW1.c,53 :: 		case  7: kp = 54; break; // 6
L_main12:
	MOVLW      54
	MOVWF      _kp+0
	GOTO       L_main5
;HW1.c,54 :: 		case  8: kp = 66; break; // B
L_main13:
	MOVLW      66
	MOVWF      _kp+0
	GOTO       L_main5
;HW1.c,55 :: 		case  9: kp = 55; break; // 7
L_main14:
	MOVLW      55
	MOVWF      _kp+0
	GOTO       L_main5
;HW1.c,56 :: 		case 10: kp = 56; break; // 8
L_main15:
	MOVLW      56
	MOVWF      _kp+0
	GOTO       L_main5
;HW1.c,57 :: 		case 11: kp = 57; break; // 9
L_main16:
	MOVLW      57
	MOVWF      _kp+0
	GOTO       L_main5
;HW1.c,58 :: 		case 12: kp = 67; break; // C
L_main17:
	MOVLW      67
	MOVWF      _kp+0
	GOTO       L_main5
;HW1.c,59 :: 		case 13: kp = 42; break; // *
L_main18:
	MOVLW      42
	MOVWF      _kp+0
	GOTO       L_main5
;HW1.c,60 :: 		case 14: kp = 48; break; // 0
L_main19:
	MOVLW      48
	MOVWF      _kp+0
	GOTO       L_main5
;HW1.c,61 :: 		case 15: kp = 35; break; // #
L_main20:
	MOVLW      35
	MOVWF      _kp+0
	GOTO       L_main5
;HW1.c,62 :: 		case 16: kp = 68; break; // D
L_main21:
	MOVLW      68
	MOVWF      _kp+0
	GOTO       L_main5
;HW1.c,63 :: 		}
L_main4:
	MOVF       _kp+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_main6
	MOVF       _kp+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_main7
	MOVF       _kp+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_main8
	MOVF       _kp+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_main9
	MOVF       _kp+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_main10
	MOVF       _kp+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_main11
	MOVF       _kp+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_main12
	MOVF       _kp+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_main13
	MOVF       _kp+0, 0
	XORLW      9
	BTFSC      STATUS+0, 2
	GOTO       L_main14
	MOVF       _kp+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_main15
	MOVF       _kp+0, 0
	XORLW      11
	BTFSC      STATUS+0, 2
	GOTO       L_main16
	MOVF       _kp+0, 0
	XORLW      12
	BTFSC      STATUS+0, 2
	GOTO       L_main17
	MOVF       _kp+0, 0
	XORLW      13
	BTFSC      STATUS+0, 2
	GOTO       L_main18
	MOVF       _kp+0, 0
	XORLW      14
	BTFSC      STATUS+0, 2
	GOTO       L_main19
	MOVF       _kp+0, 0
	XORLW      15
	BTFSC      STATUS+0, 2
	GOTO       L_main20
	MOVF       _kp+0, 0
	XORLW      16
	BTFSC      STATUS+0, 2
	GOTO       L_main21
L_main5:
;HW1.c,65 :: 		Lcd_Chr(row, col, kp); // print it on LCD
	MOVF       _row+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       _col+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       _kp+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;HW1.c,68 :: 		col++;
	INCF       _col+0, 1
;HW1.c,69 :: 		if (col > 14) {
	MOVF       _col+0, 0
	SUBLW      14
	BTFSC      STATUS+0, 0
	GOTO       L_main22
;HW1.c,70 :: 		row++;
	INCF       _row+0, 1
;HW1.c,71 :: 		col = 1;
	MOVLW      1
	MOVWF      _col+0
;HW1.c,72 :: 		}
L_main22:
;HW1.c,73 :: 		if (row > 6) {
	MOVF       _row+0, 0
	SUBLW      6
	BTFSC      STATUS+0, 0
	GOTO       L_main23
;HW1.c,74 :: 		row = 1;
	MOVLW      1
	MOVWF      _row+0
;HW1.c,75 :: 		}
L_main23:
;HW1.c,76 :: 		}
	GOTO       L_main0
;HW1.c,77 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
