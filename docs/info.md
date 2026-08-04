# Water Management System ASIC

## How it Works
The logic manages dual-tank water control. It processes lower and upper tank level probes, applies hardware debouncing[cite: 3], drives system status LEDs[cite: 3], controls pump relay state (hysteresis)[cite: 3], and latches alarm/fault outputs upon detecting missing water flow[cite: 3].

## How to Test
1. Connect clock (`clk`) and pulse active-high reset (`rst_n` is inverted inside the wrapper).
2. Set `ui_in[6]` (`LT_SIGNAL`) to High and ensure upper tank sensors are Low[cite: 2].
3. Verify `uo_out[7]` (`MOTOR`) turns High[cite: 2].
4. Toggle probe signals or `BUZZ_OFF` on `uio_in[0]` to test debouncing and alarm muting[cite: 2, 3].

## Pinout
* **ui_in[5:0]**: Upper Tank Sensors (`UP_10` through `UP_100`)[cite: 3]
* **ui_in[6]**: Lower Tank Probe (`LT_SIGNAL`)[cite: 3]
* **ui_in[7]**: Water Flow Probe (`WF_PROBE`)[cite: 3]
* **uo_out[5:0]**: Upper Tank Level LEDs[cite: 3]
* **uo_out[6]**: Lower Tank LED (`LED_LT`)[cite: 3]
* **uo_out[7]**: Motor Output (`MOTOR`)[cite: 3]
* **uio_in[0]**: Alarm Mute (`BUZZ_OFF`)[cite: 3]
* **uio_out[1]**: Error LED (`ERROR`)[cite: 3]
* **uio_out[2]**: Buzzer Driver (`BUZZER`)[cite: 3]
