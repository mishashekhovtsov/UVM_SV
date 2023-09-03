class shift_scb extends uvm_scoreboard;
    `uvm_component_utils(shift_scb)

    bit data_in[$];
    bit data_out;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    shift_tran trans;
    uvm_analysis_imp #(shift_tran, shift_scb) m_analysis_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_analysis_imp = new("m_analysis_imp", this);
    endfunction : build_phase
    
    virtual function write(shift_tran trans);
        data_in.push_back(trans.in);
        foreach (data_in[i]) begin
            `uvm_info("DATA_IN", $sformatf("data_in[%d] = %0b",i, data_in[i]), UVM_LOW)
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            wait(data_in.size() > 0);
            data_out = data_in.pop_front();
            `uvm_info("DATA_OUT", $sformatf("data_out = %0b", data_out), UVM_LOW)
        end
    endtask : run_phase

endclass : shift_scb