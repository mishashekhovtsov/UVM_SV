`include "custom_report_server.sv"

class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    custom_report_server my_report_server;
    uvm_cmdline_processor clp;

    env my_env;
    SHIFT_VSEQ vseq;
    //uvm_sequence_base vseq;

    //string VSEQ_NAME;

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
        end
        super.build_phase(phase);

        my_env = env::type_id::create("my_env", this);
        //vseq   = base_vseq::type_id::create("vseq", this);
        vseq   = SHIFT_VSEQ::type_id::create("vseq", this);
        // case(VSEQ_NAME)
        //     "SHIFT_VSEQ" : vseq = SHIFT_VSEQ::type_id::create("SHIFT_VSEQ");
        // endcase
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        
        phase.raise_objection(this);
        vseq.start(my_env.vseqr);
        phase.drop_objection(this);
    endtask : run_phase

endclass : base_test