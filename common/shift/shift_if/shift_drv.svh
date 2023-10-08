 class shift_drv extends uvm_driver #(shift_tran);
    `uvm_component_utils(shift_drv)

    virtual shift_if vif;
    
    function new(string name = "shift_drv", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        req = shift_tran::type_id::create("req");
        if(!uvm_config_db#(virtual shift_if)::get(this, "", "shift_vif", vif)) begin
            `uvm_error("L_ERR", "Could not get vif")
            `uvm_fatal("L_FAT", "FATAL")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            @(posedge vif.clk)
            if(vif.rst_n) begin
                vif.in  = req.in;
                req.out = vif.out;
            end
            seq_item_port.item_done();
        end
    endtask : run_phase

endclass : shift_drv