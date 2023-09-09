`uvm_analysis_imp_decl(_shift_in)
`uvm_analysis_imp_decl(_shift_out)
`uvm_analysis_imp_decl(_clk)

class scb extends uvm_scoreboard;
    `uvm_component_utils(scb)

    logic data_in_q[$];
    logic data_out_q[$];

    event start_check;

    int wr_cnt = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    shift_tran sh_trans;
    clk_gen_trans clk_trans;

    uvm_analysis_imp_shift_in #(shift_tran, scb) shift_in_mon_port;
    uvm_analysis_imp_shift_out #(shift_tran, scb) shift_out_mon_port;
    uvm_analysis_imp_clk #(clk_gen_trans, scb) clk_mon_port;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        shift_in_mon_port = new("shift_in_mon_port", this);
        shift_out_mon_port = new("shift_out_mon_port", this);
        clk_mon_port = new("clk_mon_port", this);
    endfunction : build_phase
    
    virtual function write_shift_in(shift_tran trans);
        data_in_q.push_back(trans.in);
        wr_cnt++;
        `uvm_info("L_INF", $sformatf("wr_cnt = %d",wr_cnt), UVM_LOW)
         // foreach (data_in_q[i]) begin
         //     `uvm_info("L_INF", $sformatf("data_in_q[%0d] = %0b",i, data_in_q[i]), UVM_LOW)
         // end
    endfunction : write_shift_in

    virtual function write_shift_out(shift_tran trans);
        data_out_q.push_back(trans.out);
        foreach (data_in_q[i]) begin
            `uvm_info("L_INF", $sformatf("data_out_q[%0d] = %0b",i, data_out_q[i]), UVM_LOW)
        end
        ->start_check;
    endfunction : write_shift_out

    virtual function write_clk(clk_gen_trans trans);
        `uvm_info("L_INF", $sformatf("CLK_IN = %0b", trans.clk), UVM_HIGH)
    endfunction : write_clk

    virtual task run_phase(uvm_phase phase);
        logic data_in;
        logic data_out;
        forever begin
            @start_check;
            data_in = data_in_q.pop_front();
            data_out = data_out_q.pop_front();
            if(data_in != data_out) begin
                `uvm_error("L_ERR", $sformatf("data_in = %b, data_out = %b", data_in, data_out))
                //`uvm_fatal("L_FAT", "FATAL")
            end
            else
                `uvm_info("L_INF", $sformatf("data_in = data_out | data_in = %b, data_out = %b", data_in, data_out), UVM_LOW)
        end
    endtask : run_phase

endclass : scb