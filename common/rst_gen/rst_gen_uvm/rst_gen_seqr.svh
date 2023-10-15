class rst_gen_seqr extends uvm_sequencer#(rst_gen_trans);
    `uvm_component_utils(rst_gen_seqr)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
endclass : rst_gen_seqr