/***********************************************************************************
 * Copyright (C) 2023 National Research University of Electronic Technology (MIET),
 * Institute of Microdevices and Control Systems.
 * See LICENSE file for licensing details.
 *
 * This file is a part of miriscv core.
 *
 ***********************************************************************************/

module miriscv_lu
  import miriscv_pkg::XLEN;
  import miriscv_lsu_pkg::*;
(
  // Clock, reset
  input  logic                    clk_i,
  input  logic                    arstn_i,

  // Data memory interface
  input  logic                    data_rvalid_i,
  input  logic [XLEN-1:0]         data_rdata_i,

  // Core pipeline signals
  input  logic                    lsu_req_i,
  input  logic                    lsu_kill_i,
  input  logic                    lsu_keep_i,
  input  logic                    lsu_we_i,
  input  logic [MEM_ACCESS_W-1:0] lsu_size_i,
  input  logic [XLEN-1:0]         lsu_addr_i,
  output logic [XLEN-1:0]         lsu_data_o,

  // Control and status signals
  output logic                    lsu_stall_o
);

  //////////
  // Load //
  //////////

  always_comb begin
    case (lsu_size_i)
      MEM_ACCESS_WORD: begin
        case (lsu_addr_i[1:0])
          2'b00:   lsu_data_o = data_rdata_i[31:0];
          default: lsu_data_o = {XLEN{1'b0}};
        endcase
      end

      MEM_ACCESS_HALF: begin
        case (lsu_addr_i[1:0])
          2'b00:   lsu_data_o = {{(XLEN-16){data_rdata_i[15]}}, data_rdata_i[15: 0]};
          2'b01:   lsu_data_o = {{(XLEN-16){data_rdata_i[23]}}, data_rdata_i[23: 8]};
          2'b10:   lsu_data_o = {{(XLEN-16){data_rdata_i[31]}}, data_rdata_i[31:16]};
          default: lsu_data_o = {XLEN{1'b0}};
        endcase
      end

      MEM_ACCESS_BYTE: begin
        case (lsu_addr_i[1:0])
          2'b00:   lsu_data_o = {{(XLEN-8){data_rdata_i[ 7]}}, data_rdata_i[ 7: 0]};
          2'b01:   lsu_data_o = {{(XLEN-8){data_rdata_i[15]}}, data_rdata_i[15: 8]};
          2'b10:   lsu_data_o = {{(XLEN-8){data_rdata_i[23]}}, data_rdata_i[23:16]};
          2'b11:   lsu_data_o = {{(XLEN-8){data_rdata_i[31]}}, data_rdata_i[31:24]};
          default: lsu_data_o = {XLEN{1'b0}};
        endcase
      end

      MEM_ACCESS_UHALF: begin
        case (lsu_addr_i[1:0])
          2'b00:   lsu_data_o = {{(XLEN-16){1'b0}}, data_rdata_i[15: 0]};
          2'b01:   lsu_data_o = {{(XLEN-16){1'b0}}, data_rdata_i[23: 8]};
          2'b10:   lsu_data_o = {{(XLEN-16){1'b0}}, data_rdata_i[31:16]};
          default: lsu_data_o = {XLEN{1'b0}};
        endcase
      end

      MEM_ACCESS_UBYTE: begin
        case (lsu_addr_i[1:0])
          2'b00:   lsu_data_o = {{(XLEN-8){1'b0}}, data_rdata_i[ 7: 0]};
          2'b01:   lsu_data_o = {{(XLEN-8){1'b0}}, data_rdata_i[15: 8]};
          2'b10:   lsu_data_o = {{(XLEN-8){1'b0}}, data_rdata_i[23:16]};
          2'b11:   lsu_data_o = {{(XLEN-8){1'b0}}, data_rdata_i[31:24]};
          default: lsu_data_o = {XLEN{1'b0}};
        endcase
      end

      default: begin
        lsu_data_o = {XLEN{1'b0}};
      end
    endcase
  end

endmodule
