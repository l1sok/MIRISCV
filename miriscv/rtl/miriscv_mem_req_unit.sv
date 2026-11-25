/***********************************************************************************
 * Copyright (C) 2023 National Research University of Electronic Technology (MIET),
 * Institute of Microdevices and Control Systems.
 * See LICENSE file for licensing details.
 *
 * This file is a part of miriscv core.
 *
 ***********************************************************************************/

module miriscv_mem_req_unit
  import miriscv_pkg::XLEN;
  import miriscv_lsu_pkg::*;
(
  // Clock, reset
  input  logic                    clk_i,
  input  logic                    arstn_i,

  // Data memory interface
  output logic                    data_req_o,
  output logic                    data_we_o,
  output logic [XLEN/8-1:0]       data_be_o,
  output logic [XLEN-1:0]         data_addr_o,
  output logic [XLEN-1:0]         data_wdata_o,

  // Core pipeline signals
  input  logic                    lsu_req_i,
  input  logic                    lsu_kill_i,
  input  logic                    lsu_keep_i,
  input  logic                    lsu_we_i,
  input  logic [MEM_ACCESS_W-1:0] lsu_size_i,
  input  logic [XLEN-1:0]         lsu_addr_i,
  input  logic [XLEN-1:0]         lsu_data_i
);

  ////////////////////////
  // Local declarations //
  ////////////////////////
  localparam BYTE_ADDR_W = $clog2(XLEN/8);
  logic [XLEN/8-1:0] data_be;
  logic [XLEN-1:0]   lsu_data;

  ///////////
  // Store //
  ///////////
  always_comb begin
    case (lsu_size_i)
      MEM_ACCESS_WORD:
        data_be = 4'b1111;
      MEM_ACCESS_UHALF,
      MEM_ACCESS_HALF:
        data_be = (4'b0011 << lsu_addr_i[1:0]);
      MEM_ACCESS_UBYTE,
      MEM_ACCESS_BYTE:
        data_be = (4'b0001 << lsu_addr_i[1:0]);
      default: begin
        data_be = {(XLEN/8){1'b0}};
      end
    endcase
  end

  always_comb begin
    case (lsu_addr_i[1:0])
      2'b00:   data_wdata_o = {lsu_data_i[31:0]};
      2'b01:   data_wdata_o = {lsu_data_i[23:0], lsu_data_i[31:24]};
      2'b10:   data_wdata_o = {lsu_data_i[15:0], lsu_data_i[31:16]};
      2'b11:   data_wdata_o = {lsu_data_i[ 7:0], lsu_data_i[31: 8]};
      default: data_wdata_o = {XLEN{1'b0}};
    endcase
  end

  assign data_req_o  = lsu_req_i & ~lsu_kill_i;
  assign data_addr_o = lsu_addr_i;
  assign data_we_o   = lsu_we_i;
  assign data_be_o   = data_be;

endmodule
