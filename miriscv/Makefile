VIVADO_SETTINGS := /tools/Xilinx/Vivado/2019.2/settings64.sh

proj: clean create_project.tcl
	source $(VIVADO_SETTINGS) && \
	vivado -mode batch -nojournal -nolog -source ./create_project.tcl

proj_open: clean create_project.tcl
	source $(VIVADO_SETTINGS) && \
	vivado -mode gui -nojournal -nolog -source ./create_project.tcl

clean:
	$(if $(wildcard .Xil), rm -r .Xil, @:)
	$(if $(wildcard tmp), rm -r tmp, @:)
