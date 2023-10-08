class clk_gen_seq extends uvm_sequence#(clk_gen_trans);
    `uvm_object_utils(clk_gen_seq)

    int rep_cnt = 1;
    
    function new (string name = "");
        super.new(name);
    endfunction 

    task body;
        req = clk_gen_trans::type_id::create("req");
        start_item(req);
        req.rep_cnt = rep_cnt;
        finish_item(req);
    endtask : body

endclass : clk_gen_seq