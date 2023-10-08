class rst_gen_mon extends uvm_monitor;
    `uvm_component_utils(rst_gen_mon)

    rst_gen_cfg cfg;
    logic last;

    function new (string name = "monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    uvm_analysis_port #(rst_gen_trans) mon_analysis_port;

    virtual rst_gen_if vif;
    rst_gen_trans item;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual rst_gen_if)::get(this, "", "rst_vif", vif)) begin
            `uvm_error("L_ERR", "Could not get vif")
            `uvm_fatal("L_FAT", "FATAL")
        end
        if(!uvm_config_db#(rst_gen_cfg)::get(this, "*", "rst_gen_cfg", cfg)) begin
            `uvm_error("L_ERR", "Could not get cgf (rst_gen_cfg)")
            `uvm_fatal("L_FAT", "FATAL")
        end
        item = new();
        mon_analysis_port = new("mon_analysis_port", this);
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            rst_changed(item);
        end
    endtask : run_phase

    virtual task rst_changed(rst_gen_trans item);
        if(cfg.async_sync == SYNC)
            @(posedge vif.clk);
        last = vif.rst_o;
        if(last != item.rst_o) begin
            item.rst_o = vif.rst_o;
            mon_analysis_port.write(item);
        end
    endtask
endclass : rst_gen_mon