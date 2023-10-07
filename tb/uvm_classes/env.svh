class env extends uvm_env;
    `uvm_component_utils(env)
    
    clk_gen_agt clk_agt;
    shift_agt sh_agt;
    scb my_scb;

    vseqr_cls vseqr;

    function new(string name = "env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        sh_agt = shift_agt::type_id::create("sh_agt", this);
        clk_agt = clk_gen_agt::type_id::create("clk_agt", this);
        my_scb = scb::type_id::create("my_scb", this);
        vseqr = vseqr_cls::type_id::create("vseqr", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sh_agt.mon.mon_analysis_in_port.connect(my_scb.shift_in_mon_port);
        sh_agt.mon.mon_analysis_out_port.connect(my_scb.shift_out_mon_port);
        clk_agt.mon.mon_analysis_port.connect(my_scb.clk_mon_port);

        vseqr.shift_in_out_seqr = sh_agt.seqr;
        vseqr.clk_gen_seqr      = clk_agt.seqr;
    endfunction : connect_phase
endclass : env