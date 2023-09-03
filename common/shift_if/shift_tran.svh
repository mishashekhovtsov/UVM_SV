class shift_tran extends uvm_sequence_item;
    `uvm_object_utils(shift_tran)

    rand bit in;
         bit out;

    virtual function string convert2str();
        return $sformatf("in=%0b, out=%0b", in, out);
    endfunction : convert2str

    function new (string name = "");
        super.new(name);
    endfunction 

endclass : shift_tran