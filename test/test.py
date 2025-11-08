# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    dut.ui_in.value = 2
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 2 | 16

    await ClockCycles(dut.clk, 5)
    dut.ui_in.value = 0 
    await ClockCycles(dut.clk, 5)
    
    dut.ui_in.value = 10
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 10 | 16

    await ClockCycles(dut.clk, 5)
    dut.ui_in.value = 0 
    await ClockCycles(dut.clk, 5)

    dut.ui_in.value = 8
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 8 | 16



    await ClockCycles(dut.clk, 20)


    dut.ui_in.value = 0 

    dut.ui_in.value = 9
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 9 | 16

    await ClockCycles(dut.clk, 5)
    dut._log.info(dut.number_one.value)
    dut.ui_in.value = 0 
    await ClockCycles(dut.clk, 5)
    
    dut.ui_in.value = 11
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 11 | 16

    await ClockCycles(dut.clk, 5)
    dut.ui_in.value = 0 
    await ClockCycles(dut.clk, 5)

    dut.ui_in.value = 5
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 5 | 16
    

    await ClockCycles(dut.clk, 20)


    dut.ui_in.value = 0 

    dut.ui_in.value = 9
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 9 | 16

    await ClockCycles(dut.clk, 5)
    dut._log.info(dut.number_one.value)
    dut.ui_in.value = 0 
    await ClockCycles(dut.clk, 5)
    
    dut.ui_in.value = 12
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 12 | 16

    await ClockCycles(dut.clk, 5)
    dut.ui_in.value = 0 
    await ClockCycles(dut.clk, 5)

    dut.ui_in.value = 9
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 9 | 16


    await ClockCycles(dut.clk, 20)


    dut.ui_in.value = 0 

    dut.ui_in.value = 4
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 4 | 16

    await ClockCycles(dut.clk, 5)
    dut._log.info(dut.number_one.value)
    dut.ui_in.value = 0 
    await ClockCycles(dut.clk, 5)
    
    dut.ui_in.value = 13
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 13 | 16

    await ClockCycles(dut.clk, 5)
    dut.ui_in.value = 0 
    await ClockCycles(dut.clk, 5)

    dut.ui_in.value = 2
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 2 | 16
    
    await ClockCycles(dut.clk, 10)

    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    #assert dut.uo_out.value == 8

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
