// Aluno: Charles Bezerra de Oliveira Júnior - 119110595
// Roteiro 3

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

  logic [3:0] operation;
  logic [2:0] A, B;
  logic [1:0] F;

  always_comb begin
    A <= SWI[7:5];
    B <= SWI[2:0];
    F <= SWI[4:3];

    case (F)
      2'b00: operation[3:0] <= A + B;
      2'b01: operation[3:0] <= A - B;
      2'b10: operation[3:0] <= A & B;
      default: operation[3:0] <= A | B;
    endcase

    {LED[7], LED[2:0]} <= operation;
  end

  always_comb begin
    case (LED[2:0])
      3'b000: SEG <= 8'b00111111;
      3'b001: SEG <= 8'b00000110;
      3'b010: SEG <= 8'b01011011;
      3'b011: SEG <= 8'b01001111;
      3'b100: SEG <= 8'b11100110;
      3'b101: SEG <= 8'b11001111;
      3'b110: SEG <= 8'b11011011;
      3'b111: SEG <= 8'b10000110;
      default: SEG <= 8'b00000000;
    endcase
  end

endmodule