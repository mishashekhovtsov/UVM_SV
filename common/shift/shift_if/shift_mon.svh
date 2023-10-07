class shift_mon extends uvm_monitor;
    `uvm_component_utils(shift_mon)

    function new (string name = "monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    uvm_analysis_port #(shift_tran) mon_analysis_in_port;
    uvm_analysis_port #(shift_tran) mon_analysis_out_port;

    virtual shift_if vif;
    shift_tran item;

    int cnt = 0;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual shift_if)::get(this, "", "shift_vif", vif)) begin
            `uvm_error("L_ERR", "Could not get vif")
            `uvm_fatal("MON", "FATAL")
        end

        item = new();
        mon_analysis_in_port = new("mon_analysis_in_port", this);
        mon_analysis_out_port = new("mon_analysis_out_port", this);
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            fork
                begin
                    @(posedge vif.clk);
                    write();
                end
                begin
                    @(posedge vif.clk);
                    read();
                end
            join            
        end
    endtask : run_phase

    virtual task write();
        item.in = vif.in;
        //`uvm_info(get_type_name(), $sformatf("Mon found packet %s", item.convert2str()), UVM_LOW)
        mon_analysis_in_port.write(item);
    endtask : write

    virtual task read();
        if (cnt == 8) begin
            item.out = vif.out;
            //`uvm_info(get_type_name(), $sformatf("Mon found packet %s", item.convert2str()), UVM_LOW)
            mon_analysis_out_port.write(item);
        end
        else 
            cnt++;
    endtask : read

endclass : shift_mon