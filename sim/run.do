set need_del 0
set debug 1
set classdebug 1
set den_gen 0

if {[file exist work/_info]} {
  echo "Work library found"
} else {
  vlib work
  vmap work work
}

if {$debug} {
      set opt -O4
      set sopt -voptargs="+acc=rn"
} else {
      set opt -O4
      set sopt -vopt
} 

if {$classdebug} {
      set cld -classdebug
} else {
      set cld -noclassdebug
} 

if {$need_del} {
   vdel -all work
   vlib work
}

set modelsim_dir /home/mixa/Programs/questasim
set uvm_lib_path /home/mixa/Programs/questasim/uvm-1.2
set uvm_src_path /home/mixa/Programs/questasim/verilog_src/uvm-1.2/src

onerror {quit -f}

vlog $opt +incdir+../tb ../src/rtl.sv

vlog -f files.f -sv

vsim  $sopt  +UVM_VERBOSITY=UVM_HIGH  $cld \
        -sv_seed random -uvmcontrol=all work.top  +UVM_TESTNAME=base_test

if {$classdebug} {
      add wave -position insertpoint sim:/top/dut/*
      #set NoQuitOnFinish 1
      onbreak {resume}
      #log /* -r
      run -all
} 
