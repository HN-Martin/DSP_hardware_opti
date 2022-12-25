global _fct_asm

;B3 = @retour
;A4 = val retour et arg1
;B4 = arg2

_fct_asm

     ZERO .L1 A5                    ;res
     MVKL .S1  9,     A0            ;i


_loop


     LDB  .D1  *A4++, A2            ;source
     NOP  4
     LDB  .D1x *B4++, A1            ;pix_buf
     NOP  4
     MPY  .M1  A2,    A1, A3        ;A3 = source[i] * pix_buf[i]
     NOP
     ADD  .L1  A5,    A3, A5        ;res += A3
     SUB  .L1  A0,    1,  A0        ;i--
[A0] B    .S1  _loop
     NOP  5
     
     MV   .D1  A5,    A4
     B    .S2  B3
     NOP  5
