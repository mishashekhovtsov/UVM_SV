class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    env my_env;
    shift_seq seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        my_env = env::type_id::create("my_env", this);
        seq = shift_seq::type_id::create("seq");
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        
        phase.raise_objection(this);
        seq.start(my_env.agt.seqr);
        phase.drop_objection(this);
    endtask : run_phase
endclass : base_test