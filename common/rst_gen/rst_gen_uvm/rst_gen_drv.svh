class rst_gen_drv extends uvm_driver #(rst_gen_trans);
    `uvm_component_utils(rst_gen_drv)

    virtual rst_gen_if vif;

    rst_gen_cfg cfg;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual rst_gen_if)::get(this, "", "rst_vif", vif)) begin
            `uvm_error("L_ERR", "Could not get vif (rst_gen_if)")
            `uvm_fatal("L_FAT", "FATAL")
        end
        if(!uvm_config_db#(rst_gen_cfg)::get(this, "*", "rst_gen_cfg", cfg)) begin
            `uvm_error("L_ERR", "Could not get cgf (rst_gen_cfg)")
            `uvm_fatal("L_FAT", "FATAL")
        end

    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            `uvm_info("L_INF", $sformatf("cfg.async_sync = %s", cfg.async_sync), UVM_LOW)
            seq_item_port.get_next_item(req);
            if(cfg.async_sync == SYNC)
                @(posedge vif.clk);
            vif.rst_o = req.rst_o;
            seq_item_port.item_done();
        end
    endtask : run_phase

endclass : rst_gen_drv