class clk_gen_agt extends uvm_agent;
    `uvm_component_utils(clk_gen_agt)

    clk_gen_drv driver;
    clk_gen_mon mon;
    //uvm_sequencer#(clk_gen_trans) seqr;
    clk_gen_seqr seqr;

    function new (string name = "agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr = clk_gen_seqr::type_id::create("seqr", this);
        mon = clk_gen_mon::type_id::create("mon", this);
        driver = clk_gen_drv::type_id::create("driver", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(seqr.seq_item_export);
    endfunction : connect_phase
endclass : clk_gen_agt