class clk_gen_drv extends uvm_driver #(clk_gen_trans);
    `uvm_component_utils(clk_gen_drv)

    virtual clk_gen_if vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual clk_gen_if)::get(this, "", "clk_vif", vif)) begin
            `uvm_error("L_ERR", "Could not get vif (clk_gen_if)")
            `uvm_fatal("DRV_CLK", "FATAL")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            vif.clk_o = req.clk;
            seq_item_port.item_done();
        end
    endtask : run_phase

endclass : clk_gen_drv