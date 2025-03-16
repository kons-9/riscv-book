.PHONY: default
default: run
PROJECT_ROOT:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

SRC:=$(shell find src -name "*.sv" -o -name "*.svh")
INCLUDE:=-Iinclude
TEST_SRC:=$(shell find test -name "tb_*.sv")

DOCKER:=$(shell which docker)
VERILATOR:=$(DOCKER) run --rm \
			-v $(PROJECT_ROOT):$(PROJECT_ROOT) \
			-w $(PROJECT_ROOT) \
			verilator/verilator:latest

VERILATOR_FLAGS:= -sv -MMD $(VERILATOR_VERSION_RELATED_FLAGS)
VERILATOR_WARNINGS?=-Wall -Wno-PINCONNECTEMPTY -Wno-UNUSED -Wno-WIDTH -Wno-SELRANGE -Wno-DECLFILENAME
VERILATOR_OPTIMIZATION_FLAG?=-O3

ifdef USING_VERILATOR_CPP
VERILATOR_CPP_TESTBENCH_FLAG?=-exe --cc
VERILATER_FLAGS+=$(VERILATOR_OPTIMIZATION_FLAG) $(VERILATOR_WARNINGS) $(VERILATOR_CPP_TESTBENCH_FLAG)
else
VERILATOR_SV_TESTBENCH_FLAG?=--timing --binary --main
VERILATER_FLAGS+=$(VERILATOR_OPTIMIZATION_FLAG) $(VERILATOR_WARNINGS) $(VERILATOR_SV_TESTBENCH_FLAG)
endif

CONCURRENT?=$(shell nproc)

# remove tb_ prefix from testbench files
TEST_TARGETS:= $(subst tb_,,$(basename $(notdir ${TEST_SRC})))
RUN_TARGETS:=$(addprefix run_,$(TEST_TARGETS))

OUTDIR:=build

.PHONY: prepare
prepare: verible.filelist

.PHONY: run
run: ${RUN_TARGETS}
	@echo "all tests done"

define TEST_RULE
.PHONY: run_$(1)
run_$(1): ${OUTDIR}/Vtb_$(1)
	cd ${OUTDIR} && ./Vtb_$(1)
endef

$(foreach test,$(TEST_TARGETS), $(eval $(call TEST_RULE,$(test))))

${OUTDIR}/Vtb_%: ${SRC} test/tb_%.sv
	$(VERILATOR) ${VERILATER_FLAGS} ${INCLUDE} ${SRC} test/tb_$*.sv --top-module tb_$* -Mdir ${OUTDIR}

.PHONY: clean
clean:
	rm -rf ${OUTDIR}

verible.filelist: ${SRC} ${TEST_SRC}
	@echo "Generating verible.filelist"
	@find src test -name "*.sv" -o -name "*.svh" > verible.filelist
