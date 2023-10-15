class shift_mon extends uvm_monitor;
    `uvm_component_utils(shift_mon)

    function new (string name = "monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    uvm_analysis_port #(shift_tran) mon_analysis_in_port;
    uvm_analysis_port #(shift_tran) mon_analysis_out_port;

    virtual shift_if vif;
    shift_tran item;
    shift_cfg cfg;

    int cnt = 0;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("L_INF", $sformatf("cfg.vif = <%s>", cfg.vif), UVM_LOW)
        if(!uvm_config_db#(virtual shift_if)::get(this, "", cfg.vif, vif)) begin
            `uvm_error("L_ERR", "Could not get vif")
            `uvm_fatal("L_FAT", "FATAL")
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
        if(cfg.SHIFT_OP == SHIFT_WR) begin 
            if(vif.rst_n) begin
                item.op = SHIFT_WR;
                item.out = vif.out;
                `uvm_info("L_INF", $sformatf("Mon found packet | OUT | %b", item.out), UVM_HIGH)
                mon_analysis_in_port.write(item);
            end
        end
    endtask : write

    virtual task read();
        if(cfg.SHIFT_OP == SHIFT_RD) begin
            if(vif.rst_n) begin
                if(vif.oe && cnt == 2) begin
                    item.op = SHIFT_RD;
                    item.in = vif.in;
                    item.oe = vif.oe;
                    `uvm_info("L_INF", $sformatf("Mon found packet | IN | %b", item.in), UVM_HIGH)
                    mon_analysis_out_port.write(item);
                end
                else if(vif.oe && cnt < 2) begin
                    cnt++;
                    item.oe = 0;
                end
                else
                    cnt = 0;
            end
            else
                cnt = 0;
        end
    endtask : read

endclass : shift_mon