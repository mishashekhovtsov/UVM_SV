class env extends uvm_env;
    `uvm_component_utils(env)
    
    clk_gen_agt clk_agt;

    rst_gen_agt rst_agt;
    rst_gen_cfg rst_cfg;

    shift_agt sh_wr_agt;
    shift_cfg sh_wr_cfg;

    shift_agt sh_rd_agt;
    shift_cfg sh_rd_cfg;

    scb my_scb;

    vseqr_cls vseqr;

    function new(string name = "env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        clk_agt = clk_gen_agt::type_id::create("clk_agt", this);
        //-------------------------------
        rst_agt = rst_gen_agt::type_id::create("rst_agt", this);
        rst_cfg = rst_gen_cfg::type_id::create("rst_cfg", this);

        rst_cfg.init(.async_sync_mode(SYNC));
        rst_agt.cfg = rst_cfg;
        //-------------------------------
        sh_wr_agt  = shift_agt::type_id::create("sh_wr_agt", this);
        sh_wr_cfg  = shift_cfg::type_id::create("sh_wr_cfg", this);

        sh_wr_cfg.init(.SHIFT_OP(shift_pkg::SHIFT_WR), .vif("shift_in_vif"));
        sh_wr_agt.cfg = sh_wr_cfg;
        //-------------------------------
        sh_rd_agt  = shift_agt::type_id::create("sh_rd_agt", this);
        sh_rd_cfg = shift_cfg::type_id::create("sh_rd_cfg", this);

        sh_rd_cfg.init(.SHIFT_OP(shift_pkg::SHIFT_RD), .vif("shift_out_vif"));
        sh_rd_agt.cfg = sh_rd_cfg;
        //-------------------------------
        my_scb  = scb::type_id::create("my_scb", this);
        vseqr   = vseqr_cls::type_id::create("vseqr", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        clk_agt.mon.mon_analysis_port.connect(my_scb.clk_mon_port);
        rst_agt.mon.mon_analysis_port.connect(my_scb.rst_mon_port);
        sh_wr_agt.mon.mon_analysis_in_port.connect(my_scb.shift_out_mon_port);
        sh_rd_agt.mon.mon_analysis_out_port.connect(my_scb.shift_in_mon_port);

        vseqr.clk_gen_seqr  = clk_agt.seqr;
        vseqr.rst_gen_seqr  = rst_agt.seqr;
        vseqr.shift_wr_seqr = sh_wr_agt.seqr;
        vseqr.shift_rd_seqr = sh_rd_agt.seqr;
    endfunction : connect_phase
endclass : env