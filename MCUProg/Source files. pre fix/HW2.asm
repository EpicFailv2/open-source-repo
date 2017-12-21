
_main:

;HW2.c,41 :: 		void main() {
;HW2.c,42 :: 		Keypad_Init(); // keypad init
	CALL       _Keypad_Init+0
;HW2.c,43 :: 		ANSEL  = 0; // make I/O digital
	CLRF       ANSEL+0
;HW2.c,44 :: 		ANSELH = 0;
	CLRF       ANSELH+0
;HW2.c,47 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;HW2.c,48 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HW2.c,49 :: 		Lcd_Out(2,1,"y = ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_HW2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HW2.c,50 :: 		Lcd_Out(3,1,"x+y = ");
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_HW2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HW2.c,51 :: 		Lcd_Out(1,1,"x = ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_HW2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HW2.c,53 :: 		while (1) {
L_main0:
;HW2.c,54 :: 		kp = 0; // reset key press variable
	CLRF       _kp+0
;HW2.c,57 :: 		while (!kp) {
L_main2:
	MOVF       _kp+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main3
;HW2.c,58 :: 		kp = Keypad_Key_Click();
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      _kp+0
;HW2.c,59 :: 		}
	GOTO       L_main2
L_main3:
;HW2.c,62 :: 		switch (kp) {
	GOTO       L_main4
;HW2.c,63 :: 		case  1: kp = 49; val = 1; break; // 1
L_main6:
	MOVLW      49
	MOVWF      _kp+0
	MOVLW      1
	MOVWF      _val+0
	GOTO       L_main5
;HW2.c,64 :: 		case  2: kp = 50; val = 2; break; // 2
L_main7:
	MOVLW      50
	MOVWF      _kp+0
	MOVLW      2
	MOVWF      _val+0
	GOTO       L_main5
;HW2.c,65 :: 		case  3: kp = 51; val = 3; break; // 3
L_main8:
	MOVLW      51
	MOVWF      _kp+0
	MOVLW      3
	MOVWF      _val+0
	GOTO       L_main5
;HW2.c,66 :: 		case  4: kp = 65; continue; break; // A
L_main9:
	MOVLW      65
	MOVWF      _kp+0
	GOTO       L_main0
;HW2.c,67 :: 		case  5: kp = 52; val = 4; break; // 4
L_main10:
	MOVLW      52
	MOVWF      _kp+0
	MOVLW      4
	MOVWF      _val+0
	GOTO       L_main5
;HW2.c,68 :: 		case  6: kp = 53; val = 5; break; // 5
L_main11:
	MOVLW      53
	MOVWF      _kp+0
	MOVLW      5
	MOVWF      _val+0
	GOTO       L_main5
;HW2.c,69 :: 		case  7: kp = 54; val = 6; break; // 6
L_main12:
	MOVLW      54
	MOVWF      _kp+0
	MOVLW      6
	MOVWF      _val+0
	GOTO       L_main5
;HW2.c,70 :: 		case  8: kp = 66; continue; break; // B
L_main13:
	MOVLW      66
	MOVWF      _kp+0
	GOTO       L_main0
;HW2.c,71 :: 		case  9: kp = 55; val = 7; break; // 7
L_main14:
	MOVLW      55
	MOVWF      _kp+0
	MOVLW      7
	MOVWF      _val+0
	GOTO       L_main5
;HW2.c,72 :: 		case 10: kp = 56; val = 8; break; // 8
L_main15:
	MOVLW      56
	MOVWF      _kp+0
	MOVLW      8
	MOVWF      _val+0
	GOTO       L_main5
;HW2.c,73 :: 		case 11: kp = 57; val = 9; break; // 9
L_main16:
	MOVLW      57
	MOVWF      _kp+0
	MOVLW      9
	MOVWF      _val+0
	GOTO       L_main5
;HW2.c,74 :: 		case 12: kp = 67; continue; break; // C
L_main17:
	MOVLW      67
	MOVWF      _kp+0
	GOTO       L_main0
;HW2.c,75 :: 		case 13: kp = 42; continue; break; // *
L_main18:
	MOVLW      42
	MOVWF      _kp+0
	GOTO       L_main0
;HW2.c,76 :: 		case 14: kp = 48; val = 0; break; // 0
L_main19:
	MOVLW      48
	MOVWF      _kp+0
	CLRF       _val+0
	GOTO       L_main5
;HW2.c,77 :: 		case 15: kp = 35; val = 0; break; // #
L_main20:
	MOVLW      35
	MOVWF      _kp+0
	CLRF       _val+0
	GOTO       L_main5
;HW2.c,78 :: 		case 16: kp = 68; continue; break; // D
L_main21:
	MOVLW      68
	MOVWF      _kp+0
	GOTO       L_main0
;HW2.c,79 :: 		}
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
;HW2.c,81 :: 		if (kp == 35) { // if # then next stage
	MOVF       _kp+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_main22
;HW2.c,82 :: 		stage++;
	INCF       _stage+0, 1
;HW2.c,83 :: 		LCD_move_cursor();
	CALL       _LCD_move_cursor+0
;HW2.c,84 :: 		} else {
	GOTO       L_main23
L_main22:
;HW2.c,85 :: 		if (kp > 47 && kp < 58) { // if number pressed then write it down
	MOVF       _kp+0, 0
	SUBLW      47
	BTFSC      STATUS+0, 0
	GOTO       L_main26
	MOVLW      58
	SUBWF      _kp+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main26
L__main37:
;HW2.c,86 :: 		Lcd_Chr_CP(kp);
	MOVF       _kp+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;HW2.c,87 :: 		}
L_main26:
;HW2.c,88 :: 		}
L_main23:
;HW2.c,91 :: 		switch (stage) {
	GOTO       L_main27
;HW2.c,92 :: 		case 1: // x input stage
L_main29:
;HW2.c,93 :: 		x = x * 10 + val;
	MOVF       _x+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       _val+0, 0
	ADDWF      R0+0, 0
	MOVWF      _x+0
;HW2.c,94 :: 		break;
	GOTO       L_main28
;HW2.c,95 :: 		case 2: // y input stage
L_main30:
;HW2.c,96 :: 		y = y * 10 + val;
	MOVF       _y+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       _val+0, 0
	ADDWF      R0+0, 0
	MOVWF      _y+0
;HW2.c,97 :: 		break;
	GOTO       L_main28
;HW2.c,98 :: 		case 3: // calculation stage
L_main31:
;HW2.c,99 :: 		LCD_sum_reset();
	CALL       _LCD_sum_reset+0
;HW2.c,100 :: 		LCD_move_cursor();
	CALL       _LCD_move_cursor+0
;HW2.c,101 :: 		WordToStr(x + y, txt);
	MOVF       _y+0, 0
	ADDWF      _x+0, 0
	MOVWF      FARG_WordToStr_input+0
	CLRF       FARG_WordToStr_input+1
	BTFSC      STATUS+0, 0
	INCF       FARG_WordToStr_input+1, 1
	MOVLW      _txt+0
	MOVWF      FARG_WordToStr_output+0
	CALL       _WordToStr+0
;HW2.c,102 :: 		Lcd_Out_CP(txt);
	MOVLW      _txt+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;HW2.c,103 :: 		x = 0;
	CLRF       _x+0
;HW2.c,104 :: 		y = 0;
	CLRF       _y+0
;HW2.c,105 :: 		stage = 1;
	MOVLW      1
	MOVWF      _stage+0
;HW2.c,106 :: 		LCD_inputs_reset();
	CALL       _LCD_inputs_reset+0
;HW2.c,107 :: 		LCD_move_cursor();
	CALL       _LCD_move_cursor+0
;HW2.c,108 :: 		break;
	GOTO       L_main28
;HW2.c,109 :: 		}
L_main27:
	MOVF       _stage+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_main29
	MOVF       _stage+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_main30
	MOVF       _stage+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_main31
L_main28:
;HW2.c,110 :: 		}
	GOTO       L_main0
;HW2.c,111 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_LCD_move_cursor:

;HW2.c,113 :: 		void LCD_move_cursor(){
;HW2.c,114 :: 		switch (stage) {
	GOTO       L_LCD_move_cursor32
;HW2.c,115 :: 		case 1: Lcd_Chr(1,4,32); break;
L_LCD_move_cursor34:
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	GOTO       L_LCD_move_cursor33
;HW2.c,116 :: 		case 2: Lcd_Chr(2,4,32); break;
L_LCD_move_cursor35:
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	GOTO       L_LCD_move_cursor33
;HW2.c,117 :: 		case 3: Lcd_Chr(3,6,32); break;
L_LCD_move_cursor36:
	MOVLW      3
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	GOTO       L_LCD_move_cursor33
;HW2.c,118 :: 		}
L_LCD_move_cursor32:
	MOVF       _stage+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_LCD_move_cursor34
	MOVF       _stage+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_LCD_move_cursor35
	MOVF       _stage+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_LCD_move_cursor36
L_LCD_move_cursor33:
;HW2.c,119 :: 		}
L_end_LCD_move_cursor:
	RETURN
; end of _LCD_move_cursor

_LCD_inputs_reset:

;HW2.c,121 :: 		void LCD_inputs_reset(){
;HW2.c,122 :: 		Lcd_Out(1,4,"     ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_HW2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HW2.c,123 :: 		Lcd_Out(2,4,"     ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_HW2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HW2.c,124 :: 		}
L_end_LCD_inputs_reset:
	RETURN
; end of _LCD_inputs_reset

_LCD_sum_reset:

;HW2.c,126 :: 		void LCD_sum_reset(){
;HW2.c,127 :: 		Lcd_Out(3,6,"     ");
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_HW2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HW2.c,128 :: 		}
L_end_LCD_sum_reset:
	RETURN
; end of _LCD_sum_reset
