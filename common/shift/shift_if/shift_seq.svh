class shift_seq extends uvm_sequence#(shift_tran);
    `uvm_object_utils(shift_seq)

    function new (string name = "");
        super.new(name);
    endfunction 

    task body;
        req = shift_tran::type_id::create("req");
        `uvm_info("SEQ", "DATA start send data to DUT", UVM_HIGH)
        start_item(req);
        req.randomize();
        finish_item(req);
        `uvm_info("SEQ", "DATA finish send data to DUT", UVM_HIGH)
    endtask : body
endclass : shift_seq