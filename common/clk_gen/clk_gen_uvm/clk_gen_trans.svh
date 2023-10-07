class clk_gen_trans extends uvm_sequence_item;
    `uvm_object_utils(clk_gen_trans)

    rand bit clk;

    virtual function string convert2str();
        return $sformatf("clk=%0b", clk);
    endfunction : convert2str

    function new (string name = "");
        super.new(name);
    endfunction 

endclass : clk_gen_trans