// Aluno: Charles Bezerra de Oliveira Júnior - 119110595
// Roteiro 2

parameter divide_by=100000000;  // divisor do clock de referência
// A frequencia do clock de referencia é 50 MHz.
// A frequencia de clk_2 será de  50 MHz / divide_by

parameter NBITS_INSTR = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;
module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
           output logic [NBITS_INSTR-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

  always_comb begin
    // SEG <= SWI;                                   
    lcd_WriteData <= SWI;
    lcd_pc <= 'h12;
    lcd_instruction <= 'h34567890;
    lcd_SrcA <= 'hab;
    lcd_SrcB <= 'hcd;
    lcd_ALUResult <= 'hef;
    lcd_Result <= 'h11;
    lcd_ReadData <= 'h33;
    lcd_MemWrite <= SWI[0];
    lcd_Branch <= SWI[1];
    lcd_MemtoReg <= SWI[2];
    lcd_RegWrite <= SWI[3];
    for(int i=0; i<NREGS_TOP; i++)
       if(i != NREGS_TOP/2-1) lcd_registrador[i] <= i+i*16;
       else                   lcd_registrador[i] <= ~SWI;
    lcd_a <= {56'h1234567890ABCD, SWI};
    lcd_b <= {SWI, 56'hFEDCBA09876543};
  end

  // Problema 1

  parameter APAGADO = 'b00000000;
  parameter ZERO = 'b00111111;
  parameter UM = 'b00000110;
  parameter DOIS = 'b01011011;

  logic [1:0] entrada;

  always_comb begin
    entrada <= SWI[1:0];

    if(~entrada[1] & ~entrada[0]) 
      SEG[7:0] <= APAGADO; 

    else if(~entrada[1] & entrada[0]) 
      SEG[7:0] <= ZERO; 

    else if(entrada[1] & ~entrada[0]) 
      SEG[7:0] <= UM; 

    else 
      SEG[7:0] <= DOIS;
  end

  // Problema 2

  logic [1:0] A;
  logic [1:0] B;
  logic router;

  always_comb begin
    A <= SWI[7:6];
    B <= SWI[5:4];

    router <= SWI[3];
    
    if (router) 
      LED[7:6] <= B;
    else 
      LED[7:6] <= A;
  end
endmodule