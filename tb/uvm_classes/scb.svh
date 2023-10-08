`uvm_analysis_imp_decl(_clk)
`uvm_analysis_imp_decl(_rst)
`uvm_analysis_imp_decl(_shift_in)
`uvm_analysis_imp_decl(_shift_out)

class scb extends uvm_scoreboard;
    `uvm_component_utils(scb)

    logic data_in_q[$];
    logic data_out;

    logic data_in;

    event start_check;

    int wr_cnt = 0;
    int rd_cnt = 0;

    logic rst;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    shift_tran    sh_trans;
    clk_gen_trans clk_trans;
    rst_gen_trans rst_trans;

    uvm_analysis_imp_clk        #(clk_gen_trans, scb) clk_mon_port;
    uvm_analysis_imp_rst        #(rst_gen_trans, scb) rst_mon_port;
    uvm_analysis_imp_shift_in   #(shift_tran   , scb) shift_in_mon_port;
    uvm_analysis_imp_shift_out  #(shift_tran   , scb) shift_out_mon_port;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        clk_mon_port       = new("clk_mon_port"      , this);
        rst_mon_port       = new("rst_mon_port"      , this);
        shift_in_mon_port  = new("shift_in_mon_port" , this);
        shift_out_mon_port = new("shift_out_mon_port", this);
    endfunction : build_phase

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        
        if(!((wr_cnt - rd_cnt) == 9)) begin
            `uvm_error("L_ERR", $sformatf("wr_cnt = %0d, rd_cnt = %0d !!!!!", wr_cnt, rd_cnt))
            `uvm_fatal("L_FAT", "FATAL")
        end
        `uvm_info("L_INF", "<><><><><><><><><><><><><><><><><><><><><><><><><><><><><>", UVM_LOW)
        `uvm_info("L_INF", "<><><><><>               SUCCESS                <><><><><>", UVM_LOW)
        `uvm_info("L_INF", "<><><><><><><><><><><><><><><><><><><><><><><><><><><><><>", UVM_LOW)
    endfunction : report_phase

    virtual function write_clk(clk_gen_trans trans);
        `uvm_info("L_INF", $sformatf("CLK_IN = %0b", trans.clk), UVM_HIGH)
    endfunction : write_clk

    virtual function write_rst(rst_gen_trans trans);
        rst = $isunknown(trans.rst_o) ? 0 : trans.rst_o;
        `uvm_info("L_INF", $sformatf("rst = %0h | SCB", rst), UVM_LOW)
        if(!rst) begin
            data_in_q.delete();
        end 
    endfunction : write_rst
    
    virtual function write_shift_in(shift_tran trans);
        if(rst) begin
            data_in_q.push_back(trans.in);
            wr_cnt++;
            `uvm_info("L_INF", $sformatf("wr_cnt = %d", wr_cnt), UVM_HIGH)
         end
    endfunction : write_shift_in

    virtual function write_shift_out(shift_tran trans);
        `uvm_info("L_INF", $sformatf("rst = %0h | SCB_OUT", rst), UVM_LOW)
        if(rst) begin
            data_out = trans.out;
            `uvm_info("L_INF", $sformatf("data_out = %0b",data_out), UVM_HIGH)
            rd_cnt++;
            ->start_check;
        end
    endfunction : write_shift_out

    virtual task run_phase(uvm_phase phase);
        forever begin
            @start_check;
            data_in = data_in_q.pop_front();
            if(data_in !== data_out) begin
                `uvm_error("L_ERR", $sformatf("data_in = %b, data_out = %b", data_in, data_out))
                `uvm_fatal("L_FAT", "FATAL")
            end
            else
                `uvm_info("L_INF", $sformatf("data_in = data_out | data_in = %b, data_out = %b", data_in, data_out), UVM_LOW)
        end
    endtask : run_phase

endclass : scb