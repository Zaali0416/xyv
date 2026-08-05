import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_wms_full_flow(dut):
    dut._log.info("Starting WMS IC Verification")

    # Start 50 MHz clock (20ns period)
    clock = Clock(dut.clk, 20, units="ns")
    cocotb.start_soon(clock.start())

    # Initial State & Reset Assertion
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)

    # 1. Test Pump Activation: Lower Tank HAS water (ui_in[6]=1), Upper tank EMPTY
    dut.ui_in.value = 0b01000000 
    await ClockCycles(dut.clk, 10)
    assert (dut.uo_out.value.integer & 0x80) != 0, "MOTOR failed to turn ON!"

    # 2. Test Fault Triggering: No water flow (ui_in[7]=0) for 60 cycles
    await ClockCycles(dut.clk, 65)
    # Check ERROR (uio_out[1]) and BUZZER (uio_out[2])
    assert (dut.uio_out.value.integer & 0x02) != 0, "ERROR failed to latch!"
    assert (dut.uio_out.value.integer & 0x04) != 0, "BUZZER failed to trip!"
    assert (dut.uo_out.value.integer & 0x80) == 0, "MOTOR failed to shut off on fault!"

    # 3. Test Alarm Mute: Set BUZZ_OFF (uio_in[0]=1)
    dut.uio_in.value = 0b00000001
    await ClockCycles(dut.clk, 10)
    assert (dut.uio_out.value.integer & 0x04) == 0, "BUZZER failed to mute!"
    assert (dut.uio_out.value.integer & 0x02) != 0, "ERROR should stay latched when muted!"

    # 4. Test Auto-Clear: Water flow resumes (ui_in[7]=1)
    dut.ui_in.value = 0b11000000
    await ClockCycles(dut.clk, 10)
    assert (dut.uio_out.value.integer & 0x02) == 0, "ERROR failed to auto-clear!"
