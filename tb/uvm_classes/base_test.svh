`include "custom_report_server.sv"

class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    custom_report_server my_report_server;
    uvm_cmdline_processor clp;

    env my_env;
    shift_seq seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);

        clp = uvm_cmdline_processor::get_inst();
    endfunction

    virtual function void build_phase(uvm_phase phase);
        string clp_uvm_args[$];
        begin
            if(!clp.get_arg_matches("+UVM_REPORT_DEFAULT", clp_uvm_args)) begin
                `ifndef UVM_1p1d
                    my_report_server  = new("my_report_server");
                `else
                    my_report_server  = new();
                `endif
            uvm_report_server::set_server( my_report_server );
        end // if (!clp.get_arg_matches("+UVM_REPORT_DEFAULT", clp_uvm_args))
        super.build_phase(phase);
        my_env = env::type_id::create("my_env", this);
        seq = shift_seq::type_id::create("seq");
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        
        phase.raise_objection(this);
        seq.start(my_env.agt.seqr);
        phase.drop_objection(this);
    endtask : run_phase
endclass : base_test