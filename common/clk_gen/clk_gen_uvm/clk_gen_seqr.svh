class clk_gen_seqr extends uvm_sequencer#(clk_gen_trans);
    `uvm_component_utils(clk_gen_seqr)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
endclass : clk_gen_seqr