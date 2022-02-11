   .arch armv8-a
   .text
 
/* print function is complete, no modifications needed */
    .global print
print:
      stp    x29, x30, [sp, -16]! //Store FP, LR.
      add    x29, sp, 0
      mov    x3, x0
      mov    x2, x1
      ldr    w0, startstring
      mov    x1, x3
      bl     printf
      ldp    x29, x30, [sp], 16
      ret
 
startstring:
   .word string0
 
    .global towers
towers:
   /* Save callee-saved registers to stack. We will need 5 so
      we save x19-x22 and w19 also we save the return address*/
      sub sp, sp, 64
      str x30, [sp]
      str x19, [sp, 8]  /*start*/
      str x20, [sp, 16] /*goal*/
      str x21, [sp, 24] /*temp*/
      str x22, [sp, 32] /*total-steps*/
      str w19, [sp, 40] /*numDisks*/
   
   /* Save a copy of all 3 incoming parameters to callee-saved registers */
      mov w19, w0 /* numDisks */
      mov x19, x1 /* Start */
      mov x20, x2 /* Goal */
     
if:
   /* Compare numDisks with 2 or (numDisks - 2)*/
      cmp w19, 1
   /* Check if less than, else branch to else */
      bne else
   /* set print function's start to incoming start */
      mov x0, x19
   /* set print function's end to goal */
      mov x1, x20
   /* call print function */
      bl print
   /* Set return register to 1 */
      add x1, xzr, 1
   /* branch to endif */
      b endif
 
 
else:
   /* Use a callee-saved variable for temp and set it to 6 */
      add x21, xzr, 6
   /* Subtract start from temp and store to itself */
      sub x21, x21, x19
   /* Subtract goal from temp and store to itself (temp = 6 - start - goal)*/
      sub x21, x21, x20
   /*subtract 1 from original numDisks and store it to numDisks parameter */
      sub w0, w19, 1
   /* Set end parameter as temp */
      mov x2, x21
   /* Call towers function */
      bl towers
   /* Save result to callee-saved register for total steps */
      mov x22, x1
   /* Set numDiscs parameter to 1 */
      add w0, wzr, 1
   /* Set start parameter to original start */
      mov x1, x19
   /* Set goal parameter to original goal */
      mov x2, x20	
   /* Call towers function */
      bl towers
   /* Add result to total steps so far */
      add x22, x1, x22
   /* Set numDisks parameter to original numDisks - 1 */
      mov w0, w20
   /* set start parameter to temp */
      mov x1, x21
   /* set goal parameter to original goal */
      mov x2, x20
   /* Call towers function */
      bl towers
   /* Add result to total steps so far and save it to return register */
      add x1, x1, x22
endif:
   /* Restore Registers */
      ldr x30, [sp]
      ldr x19, [sp, 8]
      ldr x20, [sp, 16]
      ldr x21, [sp, 24]
      ldr x22, [sp, 32]
      ldr w19, [sp, 40]
      add sp, sp, 64
 
   /* Return from towers function */
      ret    
 
 
/* Function main is complete, no modifications needed */
    .global main
main:
      stp    x29, x30, [sp, -32]!
      add    x29, sp, 0
      ldr    w0, printdata
      bl     printf
      ldr    w0, printdata + 4
      add    x1, x29, 28
      bl     scanf
      ldr    w0, [x29, 28] /* numDisks */
      mov    x1, #1 /* Start */
      mov    x2, #3 /* Goal */
      bl     towers
      mov    w4, w0
      ldr    w0, printdata + 8
      ldr    w1, [x29, 28]
      mov    w2, #1
      mov    w3, #3
      bl     printf
      mov    x0, #0
      ldp    x29, x30, [sp], 16
      ret
end:
 
printdata:
   .word string1
   .word string2
   .word string3
 
string0:
   .asciz   "Move from peg %d to peg %d\n"
string1:
   .asciz   "Enter number of discs to be moved: "
string2:
   .asciz   "%d"
   .space   1
string3:
   .ascii   "\n%d discs moved from peg %d to peg %d in %d steps."
   .ascii   "\012\000"
