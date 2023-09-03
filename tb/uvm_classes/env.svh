class env extends uvm_env;
	`uvm_component_utils(env)

	shift_agt agt;
	shift_scb scb;

	function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agt = shift_agt::type_id::create("agt", this);
        scb = shift_scb::type_id::create("scb", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        agt.mon.mon_analysis_port.connect(scb.m_analysis_imp);
    endfunction : connect_phase
endclass : env