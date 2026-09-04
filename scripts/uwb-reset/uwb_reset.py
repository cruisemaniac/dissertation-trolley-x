#!/usr/bin/env python3
# RYUW122 UWB power-on reset: pulse each NRST low->high after boot, then hold high.
# NRST pins (BCM): 17 = RHS anchor (physical pin 11), 27 = LHS anchor (physical pin 13).
# Add/remove pins here if the anchor count changes.
import os
os.environ.setdefault("GPIOZERO_PIN_FACTORY", "lgpio")   # Pi 5 backend
import signal, time
from gpiozero import OutputDevice

NRST_PINS = [17, 27]   # BCM numbers, one per UWB module

# LOW = reset asserted. Assert all, let the rail settle, then release all HIGH.
lines = [OutputDevice(p, active_high=True, initial_value=False) for p in NRST_PINS]
time.sleep(0.15)                 # hold reset ~150 ms
for ln in lines:
    ln.on()                      # HIGH = release
signal.pause()                   # keep process alive so the lines stay HIGH
