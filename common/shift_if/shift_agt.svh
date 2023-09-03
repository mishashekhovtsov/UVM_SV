class shift_agt extends uvm_agent;
    `uvm_component_utils(shift_agt)

    shift_drv driver;
    shift_mon mon;
    shift_seqr seqr;

    function new (string name = "agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr = shift_seqr::type_id::create("seqr", this);
        mon = shift_mon::type_id::create("mon", this);
        driver = shift_drv::type_id::create("driver", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(seqr.seq_item_export);
    endfunction : connect_phase
endclass : shift_agt