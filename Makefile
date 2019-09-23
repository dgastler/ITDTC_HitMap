#################################################################################
# make stuff
#################################################################################
OUTPUT_MARKUP= 2>&1 | tee ../make_log.txt | ccze -A

#################################################################################
# VIVADO stuff
#################################################################################
VIVADO_VERSION=2018.2
VIVADO_FLAGS=-notrace -mode batch
VIVADO_SHELL?="/opt/Xilinx/Vivado/"$(VIVADO_VERSION)"/settings64.sh"


#################################################################################
# Source files
#################################################################################
PL_PATH=../src
BD_PATH=../bd
CORES_PATH=../cores



#################################################################################
# Clean
#################################################################################
sim_clean :
	@cd sim && rm -rf xsim.dir vhdl webtalk* xelab* xvhdl* *.log *.jou
	@echo cleaning up sim directory


#################################################################################
# Open vivado
#################################################################################


#################################################################################
# FPGA building
#################################################################################

#################################################################################         
# Sim     
#################################################################################         
build_vdb_list = $(patsubst %.vhd,%.vdb,$(subst src/,sim/vhdl/,$(1)))                                                                                                     
define TB_RULE =    
	set -o pipefail &&\
	source $(VIVADO_SHELL) && \
	cd sim &&\
	xvhdl $@/$@.vhd $(OUTPUT_MARKUP)
	@mkdir -p sim/ && \
	source $(VIVADO_SHELL) &&\
	cd sim &&\
	xelab -debug typical $@ -s $@ $(OUTPUT_MARKUP)      
	source $(VIVADO_SHELL) &&\
	cd sim &&\
	xsim $@ -gui -t $@/setup.tcl    
endef     

#build the vdb file from a vhd file     
sim/vhdl/%.vdb : src/%.vhd    
	@echo "Building $@ from $<"     
	@rm -rf $@
	@mkdir -p sim/vhdl && \
	source $(VIVADO_SHELL) && \
	cd sim &&\
	xvhdl ../$< $(OUTPUT_MARKUP)    
	@cd sim && mkdir -p $(subst src,vhdl,$(dir $<))     
	@cd sim && ln -f -s $(PWD)/sim/xsim.dir/work/$(notdir $@) $(subst src,vhdl,$(dir $<))     

#TB_MISC_VDBS=$(call build_vdb_list, src/misc/types.vhd )

TB_HITMAP_VDBS=$(TB_MISC_VDBS) $(call build_vdb_list,  src/sub_layer.vhd src/decoder.vhd)    
tb_hitmap : $(TB_HITMAP_VDBS)  
	$(TB_RULE)     

#################################################################################
# Help 
#################################################################################

#list magic: https://stackoverflow.com/questions/4219255/how-do-you-get-the-list-of-targets-in-a-makefile
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | column

