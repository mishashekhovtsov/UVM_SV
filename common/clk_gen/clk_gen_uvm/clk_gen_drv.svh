class clk_gen_drv extends uvm_driver #(clk_gen_trans);
    `uvm_component_utils(clk_gen_drv)

    virtual clk_gen_if vif;

    int cnt = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual clk_gen_if)::get(this, "", "clk_vif", vif)) begin
            `uvm_error("L_ERR", "Could not get vif (clk_gen_if)")
            `uvm_fatal("L_FAT", "FATAL")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        vif.clk_o = 0;
        fork
            main_clk();
            wait_clk();
        join_none
    endtask : run_phase

    task main_clk();
        forever begin
            #5 vif.clk_o = !vif.clk_o;
        end
    endtask : main_clk

    task wait_clk();
        forever begin
            seq_item_port.get_next_item(req);
            repeat(req.rep_cnt) @(posedge vif.clk_o);
            //req.print();
            seq_item_port.item_done();
        end
    endtask : wait_clk

endclass : clk_gen_drv