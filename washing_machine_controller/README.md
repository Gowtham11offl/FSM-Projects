# Washing Machine Controller (FSM) — Verilog

A Verilog implementation of a washing machine controller modeled as a finite state machine (FSM). The design was simulated and verified in **Xilinx Vivado (xsim)** and synthesized/tested on a **Xilinx Artix-7 (XC7A35T-CPG236-1)** FPGA, with all FSM states exercised and verified on hardware.

## Overview

The controller models a complete wash cycle — fill, wash, drain, rinse, drain, spin, done — while handling real-world conditions such as the lid being opened mid-cycle (auto-pause/resume) and a cancel signal that resets the cycle at any point.

## FSM States

| State     | Value  | Description                                  |
|-----------|--------|-----------------------------------------------|
| `S_IDLE`   | `4'd0` | Waiting for `start`; all outputs off          |
| `S_FILL`   | `4'd1` | Filling water (`fill_valve` active)           |
| `S_WASH`   | `4'd2` | Wash cycle running (`wash_motor` active)      |
| `S_DRAIN1` | `4'd3` | Draining after wash (`drain_pump` active)     |
| `S_RINSE`  | `4'd4` | Rinse cycle running (`wash_motor` active)     |
| `S_DRAIN2` | `4'd5` | Draining after rinse (`drain_pump` active)    |
| `S_SPIN`   | `4'd6` | Spin cycle running (`spin_motor` active)      |
| `S_DONE`   | `4'd7` | Cycle complete (`done` asserted)              |
| `S_PAUSE`  | `4'd8` | Lid opened mid-cycle; cycle paused            |

The lid (`locked`) is asserted in every active state (fill, wash, drain, rinse, spin) to prevent the door from being opened while the machine is running.

### State Transition Summary

- **IDLE → FILL**: `start` asserted and `lid_closed` is high
- **FILL → WASH**: `water_full` asserted
- **WASH → DRAIN1**: `wash_done` asserted
- **DRAIN1 → RINSE**: after `DRAIN_TICKS` clock cycles
- **RINSE → DRAIN2**: `rinse_done` asserted
- **DRAIN2 → SPIN**: after `DRAIN_TICKS` clock cycles
- **SPIN → DONE**: `spin_done` asserted
- **DONE → IDLE**: after `DONE_TICKS` clock cycles
- **Any active state → PAUSE**: `lid_closed` goes low (lid opened)
- **PAUSE → resume state**: `lid_closed` goes high again
- **Any state → IDLE**: `cancel` asserted (immediate reset of the cycle)

## Module: `washing_machine_controller`

### Parameters

| Parameter     | Default | Description                                  |
|---------------|---------|-----------------------------------------------|
| `DRAIN_TICKS` | `2`     | Clock cycles spent in each drain state        |
| `DONE_TICKS`  | `2`     | Clock cycles spent in the done state          |

### Inputs

| Signal        | Width | Description                                 |
|---------------|-------|----------------------------------------------|
| `clk`         | 1     | System clock                                 |
| `rst`         | 1     | Synchronous reset                            |
| `start`       | 1     | Starts the wash cycle from `S_IDLE`          |
| `lid_closed`  | 1     | High when the lid/door is closed             |
| `water_full`  | 1     | Indicates the tub has reached target water level |
| `wash_done`   | 1     | Wash sub-cycle complete signal               |
| `rinse_done`  | 1     | Rinse sub-cycle complete signal              |
| `spin_done`   | 1     | Spin sub-cycle complete signal               |
| `cancel`      | 1     | Cancels the current cycle, returns to `S_IDLE` |

### Outputs

| Signal       | Width | Description                                  |
|--------------|-------|------------------------------------------------|
| `fill_valve` | 1     | Drives the water inlet valve                  |
| `wash_motor` | 1     | Drives the wash/agitator motor                |
| `drain_pump` | 1     | Drives the drain pump                         |
| `spin_motor` | 1     | Drives the spin motor                         |
| `done`       | 1     | Asserted when the cycle has completed         |
| `locked`     | 1     | Asserted to lock the door during an active cycle |
| `state_dbg`  | 4     | Current FSM state, exposed for debug/observation |

## Safety / Interrupt Behavior

- **Lid open mid-cycle**: if `lid_closed` drops while the machine is in any active state, the FSM saves the current state in `resume_state_q` and transitions to `S_PAUSE`. All outputs are forced off while paused. Closing the lid returns the FSM to the saved state.
- **Cancel**: asserting `cancel` immediately returns the FSM to `S_IDLE` from any state, regardless of lid status.



## Hardware Implementation

- **Target device**: Xilinx Artix-7, `XC7A35T-CPG236-1`
- Synthesized and implemented in Vivado, then programmed onto the board.
- All FSM states were verified on hardware (e.g. via LEDs/debug signals driven from `state_dbg`, or ILA/logic analyzer capture).



## Notes

- `DRAIN_TICKS` and `DONE_TICKS` are set low (`2`) by default for fast simulation; increase these for realistic timing on hardware (e.g. tied to a slower derived clock or counter scale) so drain/done states last a meaningful real-world duration.
- `state_dbg` is provided specifically to make on-hardware state verification straightforward (e.g. wire to LEDs or probe with ILA).


