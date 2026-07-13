# Lift Controller in Verilog

## Overview

This project implements a simple **Finite State Machine (FSM)-based Lift Controller** in Verilog HDL. The controller receives floor requests, determines the direction of movement, tracks the current floor, and supports an emergency stop feature.

## Features

* FSM-based control logic
* Four-floor elevator (Floors 0–3)
* Priority-based floor request handling
* Up and down movement control
* Current floor tracking
* Emergency stop functionality

## Inputs

| Signal           | Description                    |
| ---------------- | ------------------------------ |
| `clk`            | System clock                   |
| `reset`          | Asynchronous reset             |
| `floor_req[3:0]` | Floor request inputs           |
| `emergency_stop` | Stops the elevator immediately |

## Outputs

| Signal               | Description                 |
| -------------------- | --------------------------- |
| `move_up`            | Indicates upward movement   |
| `move_down`          | Indicates downward movement |
| `motor_stop`         | Stops the lift motor        |
| `current_floor[1:0]` | Current floor of the lift   |

## FSM States

* **IDLE** – Lift is waiting for a request.
* **S_MOVE_UP** – Lift moves upward toward the target floor.
* **S_MOVE_DOWN** – Lift moves downward toward the target floor.
* **EMERGENCY** – Lift stops until the emergency signal is cleared.

## How It Works

1. The controller checks the requested floors.
2. A target floor is selected using priority logic.
3. The FSM decides whether to move up, move down, or remain idle.
4. The current floor is updated as the lift moves.
5. If `emergency_stop` is asserted, the lift immediately enters the **EMERGENCY** state and the motor stops.

## Future Improvements

* Implement a request queue instead of fixed-priority selection.
* Add door open/close control.
* Include floor arrival delay.
* Support internal and external floor requests.
* Add overload and obstruction detection.

