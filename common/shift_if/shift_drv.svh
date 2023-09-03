class shift_drv extends uvm_driver #(shift_tran);
    `uvm_component_utils(shift_drv)

    virtual shift_if vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual shift_if)::get(this, "", "vif", vif)) begin
            `uvm_error("L_ERR", "Could not get vif")
            `uvm_fatal("MON", "FATAL")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            `uvm_info("DRV", "DRV_IN_PROCESS", UVM_LOW)
            seq_item_port.get_next_item(req);
            @(posedge vif.clk)
            vif.in  = req.in;
            vif.out = req.out;
            seq_item_port.item_done();
        end
    endtask : run_phase

endclass : shift_drv