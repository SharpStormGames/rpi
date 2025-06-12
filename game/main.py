import core
import pico
import time

active = False

core.log("LOG", "Init", "Game Initialisation Started")
core.log("LOG", "Pico", "Attempting Handshake with Pico")
if pico.handshake():
    core.log("LOG", "Pico", "Serial connection with Pico is functioning and handshake is complete")
else:
    core.log("ERR", "Pico", "Pico is non-responsive to serial, program will now exit")
    exit()
# TODO: Initialise Web Interface here
core.log("LOG", "Init", "Game Initialising Complete, waiting for game start signal")
while True:
    if not active:
        if pico.wait_signal("GAME_START"):
            core.log("LOG", "Game", "Game Started")
            core.switches(True)
            active = True
    if core.score["r"] == 7 or core.score["b"] == 7:
        time.sleep(1)
        core.log("LOG", "Game", "Game Finished. Waiting for signal from pico")
        pico.wait_signal("GAME_STOP")
        core.switches(False)
        core.log("LOG", "Game", "Stop signal recieved from Pico, waiting for a new game to start")
        active = False
        core.score["r"] = 0
        core.score["b"] = 0
