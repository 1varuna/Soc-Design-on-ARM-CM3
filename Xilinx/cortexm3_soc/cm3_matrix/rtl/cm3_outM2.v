//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2001-2013-2020 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//      SVN Information
//
//      Checked In          : $Date: 2012-10-15 18:01:36 +0100 (Mon, 15 Oct 2012) $
//
//      Revision            : $Revision: 225465 $
//
//      Release Information : Cortex-M System Design Kit-r1p0-01rel0
//
//-----------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------
//  Abstract            : The Output Stage is used to route the required input
//                        stage to the shared slave output.
//
//  Notes               : The bus matrix has sparse connectivity,
//                         and has a round arbiter scheme.
//
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module cm3_outM2 (

    // Common AHB signals
    HCLK,
    HRESETn,

    // Port 2 Signals
    sel_op2,
    addr_op2,
    auser_op2,
    trans_op2,
    write_op2,
    size_op2,
    burst_op2,
    prot_op2,
    master_op2,
    mastlock_op2,
    wdata_op2,
    wuser_op2,
    held_tran_op2,

    // Port 3 Signals
    sel_op3,
    addr_op3,
    auser_op3,
    trans_op3,
    write_op3,
    size_op3,
    burst_op3,
    prot_op3,
    master_op3,
    mastlock_op3,
    wdata_op3,
    wuser_op3,
    held_tran_op3,

    // Slave read data and response
    HREADYOUTM,

    active_op2,
    active_op3,

    // Slave Address/Control Signals
    HSELM,
    HADDRM,
    HAUSERM,
    HTRANSM,
    HWRITEM,
    HSIZEM,
    HBURSTM,
    HPROTM,
    HMASTERM,
    HMASTLOCKM,
    HREADYMUXM,
    HWUSERM,
    HWDATAM

    );


// -----------------------------------------------------------------------------
// Input and Output declarations
// -----------------------------------------------------------------------------

    // Common AHB signals
    input         HCLK;       // AHB system clock
    input         HRESETn;    // AHB system reset

    // Bus-switch input 2
    input         sel_op2;       // Port 2 HSEL signal
    input [31:0]  addr_op2;      // Port 2 HADDR signal
    input [31:0]  auser_op2;     // Port 2 HAUSER signal
    input  [1:0]  trans_op2;     // Port 2 HTRANS signal
    input         write_op2;     // Port 2 HWRITE signal
    input  [2:0]  size_op2;      // Port 2 HSIZE signal
    input  [2:0]  burst_op2;     // Port 2 HBURST signal
    input  [3:0]  prot_op2;      // Port 2 HPROT signal
    input  [3:0]  master_op2;    // Port 2 HMASTER signal
    input         mastlock_op2;  // Port 2 HMASTLOCK signal
    input [31:0]  wdata_op2;     // Port 2 HWDATA signal
    input [31:0]  wuser_op2;     // Port 2 HWUSER signal
    input         held_tran_op2;  // Port 2 HeldTran signal

    // Bus-switch input 3
    input         sel_op3;       // Port 3 HSEL signal
    input [31:0]  addr_op3;      // Port 3 HADDR signal
    input [31:0]  auser_op3;     // Port 3 HAUSER signal
    input  [1:0]  trans_op3;     // Port 3 HTRANS signal
    input         write_op3;     // Port 3 HWRITE signal
    input  [2:0]  size_op3;      // Port 3 HSIZE signal
    input  [2:0]  burst_op3;     // Port 3 HBURST signal
    input  [3:0]  prot_op3;      // Port 3 HPROT signal
    input  [3:0]  master_op3;    // Port 3 HMASTER signal
    input         mastlock_op3;  // Port 3 HMASTLOCK signal
    input [31:0]  wdata_op3;     // Port 3 HWDATA signal
    input [31:0]  wuser_op3;     // Port 3 HWUSER signal
    input         held_tran_op3;  // Port 3 HeldTran signal

    input         HREADYOUTM; // HREADY feedback

    output        active_op2;    // Port 2 Active signal
    output        active_op3;    // Port 3 Active signal

    // Slave Address/Control Signals
    output        HSELM;      // Slave select line
    output [31:0] HADDRM;     // Address
    output [31:0] HAUSERM;    // User Address bus
    output  [1:0] HTRANSM;    // Transfer type
    output        HWRITEM;    // Transfer direction
    output  [2:0] HSIZEM;     // Transfer size
    output  [2:0] HBURSTM;    // Burst type
    output  [3:0] HPROTM;     // Protection control
    output  [3:0] HMASTERM;   // Master ID
    output        HMASTLOCKM; // Locked transfer
    output        HREADYMUXM; // Transfer done
    output [31:0] HWUSERM;    // User data bus
    output [31:0] HWDATAM;    // Write data


// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
    wire        HCLK;       // AHB system clock
    wire        HRESETn;    // AHB system reset

    // Bus-switch input 2
    wire        sel_op2;       // Port 2 HSEL signal
    wire [31:0] addr_op2;      // Port 2 HADDR signal
    wire [31:0] auser_op2;     // Port 2 HAUSER signal
    wire  [1:0] trans_op2;     // Port 2 HTRANS signal
    wire        write_op2;     // Port 2 HWRITE signal
    wire  [2:0] size_op2;      // Port 2 HSIZE signal
    wire  [2:0] burst_op2;     // Port 2 HBURST signal
    wire  [3:0] prot_op2;      // Port 2 HPROT signal
    wire  [3:0] master_op2;    // Port 2 HMASTER signal
    wire        mastlock_op2;  // Port 2 HMASTLOCK signal
    wire [31:0] wdata_op2;     // Port 2 HWDATA signal
    wire [31:0] wuser_op2;     // Port 2 HWUSER signal
    wire        held_tran_op2;  // Port 2 HeldTran signal
    reg         active_op2;    // Port 2 Active signal

    // Bus-switch input 3
    wire        sel_op3;       // Port 3 HSEL signal
    wire [31:0] addr_op3;      // Port 3 HADDR signal
    wire [31:0] auser_op3;     // Port 3 HAUSER signal
    wire  [1:0] trans_op3;     // Port 3 HTRANS signal
    wire        write_op3;     // Port 3 HWRITE signal
    wire  [2:0] size_op3;      // Port 3 HSIZE signal
    wire  [2:0] burst_op3;     // Port 3 HBURST signal
    wire  [3:0] prot_op3;      // Port 3 HPROT signal
    wire  [3:0] master_op3;    // Port 3 HMASTER signal
    wire        mastlock_op3;  // Port 3 HMASTLOCK signal
    wire [31:0] wdata_op3;     // Port 3 HWDATA signal
    wire [31:0] wuser_op3;     // Port 3 HWUSER signal
    wire        held_tran_op3;  // Port 3 HeldTran signal
    reg         active_op3;    // Port 3 Active signal

    // Slave Address/Control Signals
    wire        HSELM;      // Slave select line
    reg  [31:0] HADDRM;     // Address
    reg  [31:0] HAUSERM;    // User Address bus
    wire  [1:0] HTRANSM;    // Transfer type
    reg         HWRITEM;    // Transfer direction
    reg   [2:0] HSIZEM;     // Transfer size
    wire  [2:0] HBURSTM;    // Burst type
    reg   [3:0] HPROTM;     // Protection control
    reg   [3:0] HMASTERM;   // Master ID
    wire        HMASTLOCKM; // Locked transfer
    wire        HREADYMUXM; // Transfer done
    reg  [31:0] HWUSERM;    // User data bus
    reg  [31:0] HWDATAM;    // Write data
    wire        HREADYOUTM; // HREADY feedback


// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
    wire        req_port2;     // Port 2 request signal
    wire        req_port3;     // Port 3 request signal

    wire  [2:0] addr_in_port;   // Address input port
    reg   [2:0] data_in_port;   // Data input port
    wire        no_port;       // No port selected signal
    reg         slave_sel;     // Slave select signal

    reg         hsel_lock;     // Held HSELS during locked sequence
    wire        next_hsel_lock; // Pre-registered hsel_lock
    wire        hlock_arb;     // HMASTLOCK modified by HSEL for arbitration

    reg         i_hselm;       // Internal HSELM
    reg   [1:0] i_htransm;     // Internal HTRANSM
    reg   [2:0] i_hburstm;     // Internal HBURSTM
    wire        i_hreadymuxm;  // Internal HREADYMUXM
    reg         i_hmastlockm;  // Internal HMASTLOCKM


// -----------------------------------------------------------------------------
// Beginning of main code
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Port Selection
// -----------------------------------------------------------------------------

  assign req_port2 = held_tran_op2 & sel_op2;
  assign req_port3 = held_tran_op3 & sel_op3;

  // Arbiter instance for resolving requests to this output stage
  cmsdk_MyArbiterNameM2 u_output_arb (

    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    .req_port2   (req_port2),
    .req_port3   (req_port3),

    .HREADYM    (i_hreadymuxm),
    .HSELM      (i_hselm),
    .HTRANSM    (i_htransm),
    .HBURSTM    (i_hburstm),
    .HMASTLOCKM (hlock_arb),

    .addr_in_port (addr_in_port),
    .no_port     (no_port)

    );


  // Active signal combinatorial decode
  always @ (addr_in_port or no_port)
    begin : p_active_comb
      // Default value(s)
      active_op2 = 1'b0;
      active_op3 = 1'b0;

      // Decode selection when enabled
      if (~no_port)
        case (addr_in_port)
          3'b010 : active_op2 = 1'b1;
          3'b011 : active_op3 = 1'b1;
          default : begin
            active_op2 = 1'bx;
            active_op3 = 1'bx;
          end
        endcase // case(addr_in_port)
    end // block: p_active_comb


  //  Address/control output decode
  always @ (
             sel_op2 or addr_op2 or trans_op2 or write_op2 or
             size_op2 or burst_op2 or prot_op2 or
             auser_op2 or
             master_op2 or mastlock_op2 or
             sel_op3 or addr_op3 or trans_op3 or write_op3 or
             size_op3 or burst_op3 or prot_op3 or
             auser_op3 or
             master_op3 or mastlock_op3 or
             addr_in_port or no_port
           )
    begin : p_addr_mux
      // Default values
      i_hselm     = 1'b0;
      HADDRM      = {32{1'b0}};
      HAUSERM     = {32{1'b0}};
      i_htransm   = 2'b00;
      HWRITEM     = 1'b0;
      HSIZEM      = 3'b000;
      i_hburstm   = 3'b000;
      HPROTM      = {4{1'b0}};
      HMASTERM    = 4'b0000;
      i_hmastlockm= 1'b0;

      // Decode selection when enabled
      if (~no_port)
        case (addr_in_port)
          // Bus-switch input 2
          3'b010 :
            begin
              i_hselm     = sel_op2;
              HADDRM      = addr_op2;
              HAUSERM     = auser_op2;
              i_htransm   = trans_op2;
              HWRITEM     = write_op2;
              HSIZEM      = size_op2;
              i_hburstm   = burst_op2;
              HPROTM      = prot_op2;
              HMASTERM    = master_op2;
              i_hmastlockm= mastlock_op2;
            end // case: 4'b010

          // Bus-switch input 3
          3'b011 :
            begin
              i_hselm     = sel_op3;
              HADDRM      = addr_op3;
              HAUSERM     = auser_op3;
              i_htransm   = trans_op3;
              HWRITEM     = write_op3;
              HSIZEM      = size_op3;
              i_hburstm   = burst_op3;
              HPROTM      = prot_op3;
              HMASTERM    = master_op3;
              i_hmastlockm= mastlock_op3;
            end // case: 4'b011

          default :
            begin
              i_hselm     = 1'bx;
              HADDRM      = {32{1'bx}};
              HAUSERM     = {32{1'bx}};
              i_htransm   = 2'bxx;
              HWRITEM     = 1'bx;
              HSIZEM      = 3'bxxx;
              i_hburstm   = 3'bxxx;
              HPROTM      = {4{1'bx}};
              HMASTERM    = 4'bxxxx;
              i_hmastlockm= 1'bx;
            end // case: default
        endcase // case(addr_in_port)
    end // block: p_addr_mux

  // hsel_lock provides support for AHB masters that address other
  // slave regions in the middle of a locked sequence (i.e. HSEL is
  // de-asserted during the locked sequence).  Unless HMASTLOCK is
  // held during these intermediate cycles, the OutputArb scheme will
  // lose track of the locked sequence and may allow another input
  // port to access the output port which should be locked
  assign next_hsel_lock = (i_hselm & i_htransm[1] & i_hmastlockm) ? 1'b1 :
                         (i_hmastlockm == 1'b0) ? 1'b0 :
                          hsel_lock;

  // Register hsel_lock
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_hsel_lock
      if (~HRESETn)
        hsel_lock <= 1'b0;
      else
        if (i_hreadymuxm)
          hsel_lock <= next_hsel_lock;
    end

  // Version of HMASTLOCK which is masked when not selected, unless a
  // locked sequence has already begun through this port
  assign hlock_arb = i_hmastlockm & (hsel_lock | i_hselm);

  assign HTRANSM    = i_htransm;
  assign HBURSTM    = i_hburstm;
  assign HSELM      = i_hselm;
  assign HMASTLOCKM = i_hmastlockm;

  // Dataport register
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_data_in_port_reg
      if (~HRESETn)
        data_in_port <= {3{1'b0}};
      else
        if (i_hreadymuxm)
          data_in_port <= addr_in_port;
    end

  // HWDATAM output decode
  always @ (
             wdata_op2 or
             wdata_op3 or
             data_in_port
           )
    begin : p_data_mux
      // Default value
      HWDATAM = {32{1'b0}};

      // Decode selection
      case (data_in_port)
        3'b010 : HWDATAM  = wdata_op2;
        3'b011 : HWDATAM  = wdata_op3;
        default : HWDATAM = {32{1'bx}};
      endcase // case(data_in_port)
    end // block: p_data_mux

  // HWUSERM output decode
  always @ (
             wuser_op2 or
             wuser_op3 or
             data_in_port
           )
    begin : p_wuser_mux
      // Default value
      HWUSERM  = {32{1'b0}};

      // Decode selection
      case (data_in_port)
        3'b010 : HWUSERM  = wuser_op2;
        3'b011 : HWUSERM  = wuser_op3;
        default : HWUSERM  = {32{1'bx}};
      endcase // case(data_in_port)
    end // block: p_wuser_mux

  // ---------------------------------------------------------------------------
  // HREADYMUXM generation
  // ---------------------------------------------------------------------------
  // The HREADY signal on the shared slave is generated directly from
  //  the shared slave HREADYOUTS if the slave is selected, otherwise
  //  it mirrors the HREADY signal of the appropriate input port
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_slave_sel_reg
      if (~HRESETn)
        slave_sel <= 1'b0;
      else
        if (i_hreadymuxm)
          slave_sel  <= i_hselm;
    end

  // HREADYMUXM output selection
  assign i_hreadymuxm = (slave_sel) ? HREADYOUTM : 1'b1;

  // Drive output with internal version of the signal
  assign HREADYMUXM = i_hreadymuxm;


endmodule

// --================================= End ===================================--
