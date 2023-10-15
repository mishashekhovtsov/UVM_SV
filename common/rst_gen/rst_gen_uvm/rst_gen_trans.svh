class rst_gen_trans extends uvm_sequence_item;
    `uvm_object_utils(rst_gen_trans)

    rand bit rst_o;

    virtual function string convert2str();
        return $sformatf("rst_o=%0b", rst_o);
    endfunction : convert2str

    function new (string name = "");
        super.new(name);
    endfunction 

endclass : rst_gen_trans