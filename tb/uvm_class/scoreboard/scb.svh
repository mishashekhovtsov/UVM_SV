`uvm_analysis_imp_decl(_clk)
`uvm_analysis_imp_decl(_rst)
`uvm_analysis_imp_decl(_shift_in)
`uvm_analysis_imp_decl(_shift_out)

class scb extends uvm_scoreboard;
    `uvm_component_utils(scb)

    logic data_out_q[$];
    logic data_in;

    logic data_out;

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
            `uvm_info("L_INF", $sformatf("wr_cnt = %0d, rd_cnt = %0d !!!!!", wr_cnt, rd_cnt), UVM_LOW)
            //`uvm_fatal("L_FAT", "FATAL")
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
        `uvm_info("L_INF", $sformatf("rst = %0h | SCB", rst), UVM_HIGH)
        if(!rst) begin
            data_out_q.delete();
        end 
    endfunction : write_rst
    
    virtual function write_shift_out(shift_tran trans);
        `uvm_info("L_INF", $sformatf("rst = %0h | SCB_OUT", rst), UVM_HIGH)
        if(rst) begin
            case(trans.op)
                SHIFT_WR: begin
                    `uvm_info("L_INF", $sformatf("trans.op = %s", trans.op.name()), UVM_HIGH)
                    if(data_out_q.size() > 10)
                        data_out_q.delete(0);
                    data_out_q.push_back(trans.out);
                    wr_cnt++;
                    `uvm_info("L_INF", $sformatf("wr_cnt = %d", wr_cnt), UVM_HIGH)
                end
                SHIFT_RD: begin
                    `uvm_error("L_ERR", "ERROR SHIFT_OUT OP in SCB")
                    `uvm_fatal("L_FAT", ">>>>>FAIL")
                end
            endcase // trans.op              
         end
    endfunction : write_shift_out

    virtual function write_shift_in(shift_tran trans);
        `uvm_info("L_INF", $sformatf("rst = %0h | SCB_OUT", rst), UVM_HIGH)
        if(rst) begin
            case(trans.op)
                SHIFT_WR: begin
                    `uvm_error("L_ERR", "ERROR SHIFT_IN OP in SCB")
                    `uvm_fatal("L_FAT", ">>>>>FAIL")
                end
                SHIFT_RD: begin
                    if(trans.oe) begin
                        `uvm_info("L_INF", $sformatf("trans.op = %s", trans.op.name()), UVM_HIGH)
                        data_in = trans.in;
                        `uvm_info("L_INF", $sformatf("data_in = %0b",data_in), UVM_HIGH)
                        rd_cnt++;
                        ->start_check;
                    end
                end
            endcase // trans.op
        end
    endfunction : write_shift_in

    virtual task run_phase(uvm_phase phase);
        forever begin
            @start_check;
            data_out = data_out_q.pop_front();
            if(data_out !== data_in) begin
                `uvm_error("L_ERR", $sformatf("data_out = %b, data_in = %b", data_out, data_in))
                //`uvm_fatal("L_FAT", "FATAL")
            end
            else
                `uvm_info("L_INF", $sformatf("data_out = data_in | data_out = %b, data_in = %b", data_out, data_in), UVM_LOW)
        end
    endtask : run_phase

endclass : scb