class shift_seqr extends uvm_sequencer#(shift_tran);
    `uvm_component_utils(shift_seqr)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
endclass : shift_seqr