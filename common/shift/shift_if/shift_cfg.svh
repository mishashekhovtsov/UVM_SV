class shift_cfg extends uvm_object;
    uvm_sequencer_base pseqr;
    `uvm_object_utils(shift_cfg)

    SHIFT_OP_t SHIFT_OP;
    string vif;

    function new (string name = "");
        super.new(name);
    endfunction 

    function void init(SHIFT_OP_t SHIFT_OP, string vif);
        this.SHIFT_OP = SHIFT_OP;
        this.vif      = vif;
    endfunction : init

    virtual function void set_seqr(uvm_sequencer_base seqr);
        pseqr = seqr;
    endfunction : set_seqr

    virtual function uvm_sequencer_base get_seqr();
        return pseqr;
    endfunction : get_seqr

endclass : shift_cfg