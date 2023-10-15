class shift_tran extends uvm_sequence_item;
    `uvm_object_utils(shift_tran)
    SHIFT_OP_t op;
    rand logic in;
    rand logic oe;
         logic out;

    virtual function string convert2str();
        return $sformatf("in=%0b, out=%0b, oe=%0b", in, out, oe);
    endfunction : convert2str

    function new (string name = "");
        super.new(name);
    endfunction 

endclass : shift_tran