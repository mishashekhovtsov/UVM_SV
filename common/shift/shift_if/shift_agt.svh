class shift_agt extends uvm_agent;
    shift_drv driver;
    shift_mon mon;
    shift_seqr seqr;
    shift_cfg cfg;
    //uvm_sequencer#(shift_tran) seqr;

    `uvm_component_utils_begin(shift_agt)
        `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_component_utils_end

    function new (string name = "agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon    = shift_mon::type_id::create("mon", this);
        driver = shift_drv::type_id::create("driver", this);
        seqr   = shift_seqr::type_id::create("seqr", this);
        //pseqr = seqr;
        //cfg.set_seqr(seqr);
        driver.cfg = cfg;
        mon.cfg = cfg;
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(seqr.seq_item_export);
        driver.rsp_port.connect(seqr.rsp_export);
    endfunction : connect_phase
endclass : shift_agt