import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge

@cocotb.test()
async def test_wms_basic_operation(dut):
    dut._log.info("Starting WMS IC Basic Test")

    # Start 50 MHz clock
    clock = Clock(dut.clk, 20, units="ns")
    cocotb.start_soon(clock.start())

    # Initialize Inputs
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    # Apply Reset
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)

    # Test Pump Activation: Lower Tank HAS water (ui_in[6] = 1), Upper tank EMPTY (ui_in[5:0] = 0)
    dut.ui_in.value = 0b01000000 
    await ClockCycles(dut.clk, 20)

    # Motor Output is at uo_out[7]
    assert (dut.uo_out.value & 0x80) != 0, "MOTOR failed to turn ON when lower tank has water!"
    dut._log.info("Pass: Motor turned ON as expected.")
