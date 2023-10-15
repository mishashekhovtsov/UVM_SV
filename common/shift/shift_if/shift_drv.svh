 class shift_drv extends uvm_driver#(shift_tran);
    `uvm_component_utils(shift_drv)

    virtual shift_if vif;
    uvm_sequence_item item;
    shift_cfg cfg;
    shift_tran pkt;

    function new(string name = "shift_drv", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("L_INF", $sformatf("cfg.vif = <%s>", cfg.vif), UVM_LOW)
        pkt = shift_tran::type_id::create("pkt");
        if(!uvm_config_db#(virtual shift_if)::get(this, "", cfg.vif, vif)) begin
            `uvm_error("L_ERR", "Could not get vif")
            `uvm_fatal("L_FAT", "FATAL")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get(item);
            void'($cast(pkt, item));
            if(pkt == null) `uvm_fatal(get_name(), "casting failed or item returned null")

            fork
                begin
                    automatic shift_tran req, rsp;
                    req = pkt;
                    $cast(rsp, req.clone());
                    @(posedge vif.clk)
                    case(req.op)
                        SHIFT_WR: begin
                            if(vif.rst_n) begin
                                vif.out  = req.out;
                            end
                        end
                        SHIFT_RD: begin
                            if(vif.rst_n) begin
                                vif.oe = req.oe;
                                rsp.in = vif.in;
                            end
                        end
                        default: begin
                            `uvm_fatal("L_FAT", "FATAL_DRIVER_OP")
                        end
                    endcase // req.op
                    rsp.set_id_info(req);
                    seq_item_port.put(rsp);
                end
            join_none
        end
    endtask : run_phase

endclass : shift_drv