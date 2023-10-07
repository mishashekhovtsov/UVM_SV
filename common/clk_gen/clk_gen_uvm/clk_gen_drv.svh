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
            `uvm_fatal("DRV_CLK", "FATAL")
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
            `uvm_info("CLK", $sformatf("vif.clk_o = %0d", vif.clk_o), UVM_HIGH)
            #5 vif.clk_o = !vif.clk_o;
        end
    endtask : main_clk

    task wait_clk();
        forever begin
            `uvm_info("CLK", $sformatf("vif.clk_o = %0d", vif.clk_o), UVM_HIGH)
            seq_item_port.get_next_item(req);
            cnt=0;
            repeat(req.rep_cnt) begin
                `uvm_info("REP_CNT", $sformatf("rep_cnt = %0d", cnt), UVM_HIGH)
                @(posedge vif.clk_o);
                cnt++;
            end
            req.rep_cnt = 0;
            `uvm_info("REP_CNT", "END WAIT", UVM_LOW) 
            `uvm_info("REP_CNT", $sformatf("rep_cnt = %0d", cnt), UVM_LOW)
            req.print();
            seq_item_port.item_done();
        end
    endtask : wait_clk

endclass : clk_gen_drv