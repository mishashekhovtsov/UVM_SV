class shift_seq extends uvm_sequence#(shift_tran);
    `uvm_object_utils(shift_seq)

    function new (string name = "");
        super.new(name);
    endfunction 

    task body;
        repeat(16) begin
            `uvm_info("SEQ", "SEQ_IN_PROCESS", UVM_LOW)
            req = shift_tran::type_id::create("req");
            start_item(req);
            req.randomize();
            finish_item(req);
        end
        `uvm_info("SEQ", "Done generation seq", UVM_LOW)
    endtask : body
endclass : shift_seq