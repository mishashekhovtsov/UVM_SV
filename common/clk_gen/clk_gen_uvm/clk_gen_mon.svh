class clk_gen_mon extends uvm_monitor;
    `uvm_component_utils(clk_gen_mon)

    function new (string name = "monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    uvm_analysis_port #(clk_gen_trans) mon_analysis_port;

    virtual clk_gen_if vif;
    clk_gen_trans item;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual clk_gen_if)::get(this, "", "clk_vif", vif)) begin
            `uvm_error("L_ERR", "Could not get vif")
            `uvm_fatal("L_FAT", "FATAL")
        end

        item = new();
        mon_analysis_port = new("mon_analysis_port", this);
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            clk_in(item);
            //`uvm_info(get_type_name(), $sformatf("Mon found packet %s", item.convert2str()), UVM_LOW)
            mon_analysis_port.write(item);
        end
    endtask : run_phase

    virtual task clk_in(clk_gen_trans item);
        @(posedge vif.clk_o)
        item.clk = vif.clk_o;
    endtask
endclass : clk_gen_mon