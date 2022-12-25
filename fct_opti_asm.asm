      .global _fct_opti_asm

;B3 = @retour
;A4 = val retour et arg1
;B4 = arg2

_fct_opti_asm:
;https://maixx.files.wordpress.com/2012/02/wiley_digital_signal-processing_and_applications_with_the_c6713_and_c6416_dsk.pdf
;https://fac.umc.edu.dz/fstech/cours/Electronique/M2%20R%20&%20T/DSP%20FPGA.pdf


       LDW   .D1   *A4++,  A1                    ;source           3 & 2 & 1 & 0
||     LDW   .D2   *B4++,  B1                    ;pix_buf          3 & 2 & 1 & 0
||     MVKL  .S1   24,     A3

       LDW   .D1   *A4++,  A2                    ;source           7 & 6 & 5 & 4
||     LDW   .D2   *B4++,  B2                    ;pix_buf          7 & 6 & 5 & 4
||     MVKL  .S1   0x00FF, A9
||     MVKL  .S2   0x00FF, B9

       LDB   .D1   *A4++,  A8                    ;source           8
||     LDB   .D2   *B4++,  B8                    ;pix_buf          8
||     SHL   .S1   A9,     24, A7
||     SHL   .S2   B9,     16, B7

       ADD   .L1   A7,     A9, A9                ;0xFF0000FF
||     SHL   .S2   B9,     8,  B9
||     SHL   .S1   A3,     5,  A0

       ADD   .L1   A3,     A0, A0
||     ADD   .L2   B7,     B9, B9                ;0x00FFFF00

       AND   .L1   A1,     A9, A5                ;source           0 & 3
||     AND   .L2x  B9,     A1, B5                ;source           1 & 2
||     EXT   .S1x  B1,     A3, A7                ;pix_buf          3
||     EXT   .S2   B1,     16, 24,  B7           ;pix_buf          1

       AND   .L1   A2,     A9, A6                ;source           4 & 7
||     AND   .L2x  B9,     A2, B6                ;source           5 & 6
||     EXT   .S1x  B2,     A3, A4                ;pix_buf          7
||     EXT   .S2   B2,     16, 24,  B4           ;pix_buf          5
||     MPYLH .M1   A7,     A5, A7                ;source * pix_buf 3 << 8
||     MPY   .M2   B7,     B5, B7                ;source * pix_buf 1 << 8

       EXT   .S1x  B1,     A0, A1                ;pix_buf          0
||     EXT   .S2   B1,     8,  24,  B1           ;pix_buf          2
||     MPYLH .M1   A4,     A6, A4                ;source * pix_buf 7 << 8
||     MPY   .M2   B4,     B6, B4                ;source * pix_buf 5 << 8

       EXT   .S1x  B2,     A0, A9                ;pix_buf          4
||     EXT   .S2   B2,     8,  24,  B9           ;pix_buf          6
||     MPY   .M1   A1,     A5, A1                ;source * pix_buf 0
||     MPYLH .M2   B1,     B5, B1                ;source * pix_buf 2

       ADD   .D1   A7,     A4, A4                ;source * pix_buf 3 + 7 << 8
||     ADD   .D2   B7,     B4, B4                ;source * pix_buf 5 + 1 << 8
||     MPY   .M1   A9,     A6, A2                ;source * pix_buf 4
||     MPYLH .M2   B9,     B6, B2                ;source * pix_buf 6
||     B     .S2   B3

       EXT   .S1   A4,     0,  8,   A4           ;source * pix_buf 3 + 7
||     EXT   .S2   B4,     0,  8,   B4           ;source * pix_buf 5 + 1
||     MPY   .M2x  B8,     A8, B8                ;source * pix_buf 8

       ADD   .D1   A1,     A2, A7                ;source * pix_buf 0 + 4
||     ADD   .D2   B1,     B2, B7                ;source * pix_buf 2 + 6
||     ADD   .L1x  A4,     B4, A4                ;source * pix_buf 3 + 7 + 5 + 1

       ADD   .D1   A4,     A7, A4                ;source * pix_buf 0 + 4 + 3 + 7 + 5 + 1
||     ADD   .D2   B7,     B8, B7                ;source * pix_buf 8 + 2 + 6

       ADD   .S1x  A4,     B7, A4                ;source * pix_buf 0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8

