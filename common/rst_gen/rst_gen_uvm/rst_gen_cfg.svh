class rst_gen_cfg extends uvm_object;
    `uvm_object_utils(rst_gen_cfg)

    async_sync_t async_sync = ASYNC;

    function new (string name = "");
        super.new(name);
    endfunction 

    function void init (input async_sync_t async_sync_mode);
        this.async_sync = async_sync_mode;
    endfunction 

endclass : rst_gen_cfg