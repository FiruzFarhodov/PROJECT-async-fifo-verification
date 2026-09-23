Readme · MD
Asynchronous FIFO — Design & UVM-Style Verification

A parameterized, dual-clock (asynchronous) FIFO implemented in SystemVerilog, based on the classic Clifford E. Cummings gray-code pointer synchronization architecture, verified with a custom class-based (UVM-style) testbench.

Overview

This project implements and verifies an asynchronous FIFO that safely transfers data between two independent clock domains (write clock wclk and read clock rclk) using gray-coded pointers and two-flop synchronizers to avoid metastability.

The verification environment is a layered, transaction-based testbench (generator → driver → monitor → scoreboard) with a reusable interface, SVA protocol assertions, and functional coverage — following standard UVM methodology concepts without depending on the UVM library itself.

Architecture
Design (design.sv + submodules)
Module	Description
FIFO1	Top-level FIFO wrapper connecting all submodules
fifomem.sv	Dual-port memory array storing FIFO data
wptr_full.sv	Write-domain binary/gray pointer logic and full-flag generation
rptr_empty.sv	Read-domain binary/gray pointer logic and empty-flag generation
sync_r2w.sv	Two-flop synchronizer bringing the read pointer into the write clock domain
sync_w2r.sv	Two-flop synchronizer bringing the write pointer into the read clock domain

Parameters: DSIZE (data width, default 8), ASIZE (address width, default 4 → depth 16).

Verification Environment
generator → [mailbox] → driver → DUT (FIFO1) → monitor → [mailbox] → scoreboard
                                     ↑
                              mem_interface (clocking blocks)
Component	File	Role
transaction.sv	Randomized stimulus item (wdata, winc, rinc)	
generator.sv	Produces randomized transactions; base class extended per test	
driver.sv	Drives write/read signals onto the DUT via clocking blocks, respecting wfull/rempty	
interface.sv	mem_interface — signals + clocking blocks/modports for driver and monitor	
monitor.sv	Passively samples write and read activity, packages observed transactions	
scoreboard.sv	Reference model queue (fifo_q); checks read data against expected write order	
environment.sv	Instantiates and connects generator, driver, monitor, scoreboard; runs pre_test / test / post_test phases	
assertions.sv	SVA properties: no write while full, no read while empty	
covergroups.sv	Functional coverage on wfull/winc and rempty/rinc, including cross coverage	
Test Cases
Test	File	Purpose
test_random	test_random.sv	Unconstrained random read/write traffic for general regression
test_write_only	test_write_only.sv	Writes only, runs until wfull asserts
test_read_only	test_read_only.sv	Reads only, runs until rempty asserts
test_fifo_full	test_fifo_full.sv	Directed test targeting the full condition
test_fifo_empty	test_fifo_empty.sv	Fills the FIFO, then drains it to explicitly hit the empty condition

testbench.sv (fifo_tb) instantiates the DUT, the interface, clock generation, and the active test (selected via `include — only one test is active at a time, toggled by (un)commenting).

Repository Structure
.
├── design.sv              # Top-level FIFO module
├── fifomem.sv              # FIFO memory array
├── wptr_full.sv             # Write pointer + full flag
├── rptr_empty.sv            # Read pointer + empty flag
├── sync_r2w.sv              # Read-to-write pointer synchronizer
├── sync_w2r.sv              # Write-to-read pointer synchronizer
├── interface.sv             # Virtual interface + clocking blocks
├── transaction.sv           # Stimulus transaction class
├── generator.sv             # Base stimulus generator
├── driver.sv                # Signal-level driver
├── monitor.sv                # Passive protocol monitor
├── scoreboard.sv             # Self-checking reference model
├── environment.sv            # Testbench environment/phasing
├── assertions.sv             # SVA protocol checks
├── covergroups.sv            # Functional coverage
├── testbench.sv              # Top-level testbench module
├── test_random.sv            # Random traffic test
├── test_write_only.sv        # Write-only directed test
├── test_read_only.sv         # Read-only directed test
├── test_fifo_full.sv         # Full-condition directed test
├── test_fifo_empty.sv        # Empty-condition directed test
└── run.sh                    # VCS simulation run script
Running the Simulation

Simulation is run with Synopsys VCS:
EdaPlayground Link: https://www.edaplayground.com/x/hND5



bash
./run.sh

run.sh compiles design.sv and testbench.sv with -sverilog, elevates all warnings, runs simv, and archives the results directory into result.zip. To run a different test, edit testbench.sv to `include the desired test file and instantiate it in fifo_tb instead of test_random.

Checking & Coverage
Assertions (assertions.sv): flag illegal writes while wfull is asserted and illegal reads while rempty is asserted.
Scoreboard: maintains an in-order reference queue of written data and compares it against data returned on each read, flagging mismatches.
Functional coverage (covergroups.sv): cross-covers full/write-enable and empty/read-enable activity to confirm boundary conditions were exercised.
## Known Issues & Future Improvements

This project is still a work in progress. I've run into timeout errors in some of the test cases along with a few other minor issues that I'm still working through. Planned future improvements include cleaning up the test cases and resolving these issues.

Author
Firuz Farhodov — github.com/FiruzFarhodov
