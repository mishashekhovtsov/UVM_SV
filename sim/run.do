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

#onerror {quit -f}

vlog $opt +incdir+../tb ../src/rtl.sv

vlog -f files.f -sv

#if [expr {${comperror}!=""}] then {
#      echo "ERROR COMPILE!!!!"
#      quit -f
#} else {
#      vsim  $sopt  +UVM_VERBOSITY=UVM_HIGH  $cld \
#        -uvmcontrol=all work.top  +UVM_TESTNAME=base_test
#}

vsim  $sopt  +UVM_VERBOSITY=UVM_HIGH  $cld \
        -sv_seed random -uvmcontrol=all work.top  +UVM_TESTNAME=base_test

if {$classdebug} {
      add wave top/vif/clk
      add wave top/vif/in
      add wave top/vif/out
      add wave top/dut/clk
      add wave top/dut/rst_n
      add wave top/dut/in
      add wave top/dut/q
      add wave top/dut/reg_shift
      run -all
} 

#view -undock wave 
#do proj_wave.do 


