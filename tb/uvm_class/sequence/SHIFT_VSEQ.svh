class SHIFT_VSEQ extends base_vseq;
    `uvm_object_utils(SHIFT_VSEQ)

    int CNT = 0;

    int cnt = 0;

    bit flag_rd = 0;

    function new(string name = "SHIFT_VSEQ");
        super.new(name);

    endfunction

    virtual task body();
        super.body();
        `uvm_info("L_INF", "START VSEQ", UVM_LOW)
        reset();
        CNT = $urandom_range(100, 1000);
        for(int i = 0; i < CNT; i++) begin
            fork 
                begin : write
                    sh_write_seq.out = $urandom_range(0, 1);
                    `uvm_info("L_INF", $sformatf("OUT | sh_write_seq.out = %0h", sh_write_seq.out), UVM_HIGH)
                    `uvm_send(sh_write_seq)

                    if(cnt == 7)
                        flag_rd = 1;
                    else
                        cnt++;
                end
                begin : read
                    if(flag_rd) begin
                        sh_read_seq.oe = 1;
                        `uvm_send(sh_read_seq)
                        `uvm_info("L_INF", $sformatf("IN | sh_read_seq.in = %0h", sh_read_seq.in), UVM_HIGH)
                    end
                end
            join
        end

        clk_seq.rep_cnt = 2;
        `uvm_send(clk_seq) 
        sh_read_seq.oe = 0;
        `uvm_send(sh_read_seq)

        clk_seq.rep_cnt = 40;
        `uvm_send(clk_seq)     

    endtask : body

endclass : SHIFT_VSEQ