class clk_gen_seq extends uvm_sequence#(clk_gen_trans);
    `uvm_object_utils(clk_gen_seq)

    function new (string name = "");
        super.new(name);
    endfunction 

    task body;
        req = clk_gen_trans::type_id::create("req");
        req.clk = 0;
        forever begin
            start_item(req);
            #5 req.clk = ~req.clk;
            finish_item(req);
        end
    endtask : body
endclass : clk_gen_seq