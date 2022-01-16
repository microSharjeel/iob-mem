MODULES+=ram/t2p_asym_ram

# Paths
T2P_ASYM_RAM_DIR=$(MEM_HW_DIR)/ram/t2p_asym_ram

# Submodules
ifneq (ram/t2p_ram,$(filter ram/t2p_ram, $(MODULES)))
include $(MEM_HW_DIR)/ram/t2p_ram/hardware.mk
endif

# Sources
VSRC+=$(T2P_ASYM_RAM_DIR)/iob_t2p_asym_ram.v


#W_WIDE_R_NARROW=1

ifeq ($(W_WIDE_R_NARROW),1)
DEFINE += "$(defmacro)W_WIDE_R_NARROW=1"
DEFINE += $(defmacro)W_DATA_W=4
DEFINE += $(defmacro)W_ADDR_W=4
DEFINE += $(defmacro)R_DATA_W=1
DEFINE += $(defmacro)R_ADDR_W=6
else
DEFINE += "$(defmacro)W_NARROW_R_WIDE=1"
DEFINE += $(defmacro)R_DATA_W=4
DEFINE += $(defmacro)R_ADDR_W=4
DEFINE += $(defmacro)W_DATA_W=1
DEFINE += $(defmacro)W_ADDR_W=6
endif
