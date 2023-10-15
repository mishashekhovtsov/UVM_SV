class rst_gen_agt extends uvm_agent;
    `uvm_component_utils(rst_gen_agt)

    rst_gen_drv driver;
    rst_gen_cfg cfg;
    rst_gen_mon mon;
    rst_gen_seqr seqr;

    function new (string name = "agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr = rst_gen_seqr::type_id::create("seqr", this);
        mon = rst_gen_mon::type_id::create("mon", this);
        driver = rst_gen_drv::type_id::create("driver", this);
        driver.cfg = cfg;
        mon.cfg    = cfg;
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(seqr.seq_item_export);
    endfunction : connect_phase
endclass : rst_gen_agt