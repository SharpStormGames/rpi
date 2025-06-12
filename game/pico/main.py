from machine import Pin
from picozero import LED, Button
import time, sys, select

active = False
score = {"b": 0, "r": 0}
dp1 = [Pin(2, Pin.OUT), Pin(3, Pin.OUT), Pin(4, Pin.OUT), Pin(5, Pin.OUT), Pin(6, Pin.OUT), Pin(1, Pin.OUT), Pin(0, Pin.OUT)]
dp2 = [Pin(14, Pin.OUT), Pin(15, Pin.OUT), Pin(11, Pin.OUT), Pin(10, Pin.OUT), Pin(9, Pin.OUT), Pin(13, Pin.OUT), Pin(12, Pin.OUT)]
sBTN = Button(17)
bLED = LED(7)
rLED = LED(8)

patterns = {
    "0": [1, 1, 1, 1, 1, 1, 0],  # 0
    "1": [0, 1, 1, 0, 0, 0, 0],  # 1
    "2": [1, 1, 0, 1, 1, 0, 1],  # 2
    "3": [1, 1, 1, 1, 0, 0, 1],  # 3
    "4": [0, 1, 1, 0, 0, 1, 1],  # 4
    "5": [1, 0, 1, 1, 0, 1, 1],  # 5
    "6": [1, 0, 1, 1, 1, 1, 1],  # 6
    "7": [1, 1, 1, 0, 0, 0, 0],  # 7
}

def display_set(display, character):
    pattern = patterns[character]
    for i, pin in enumerate(display):
        pin.value(pattern[i])

def start_game():
    global active
    active = True
    print("GAME_START")
    sys.stdout.write('')
    display_set(dp1, "0")
    display_set(dp2, "0")

sBTN.when_pressed = start_game

while True:
    try:
        if select.select([sys.stdin], [], [], 0)[0]:
            first_char = sys.stdin.buffer.read(1)
            if first_char:
                remain_char = sys.stdin.buffer.readline().decode().strip()
                signal = first_char.decode() + remain_char

                if signal == "REQ_HANDSHAKE":
                    print("ACK_HANDSHAKE")
                    display_set(dp1, "0")
                    display_set(dp2, "0")
                    sys.stdout.write('')

                elif signal == "BSCORE" and active:
                    score["b"] += 1
                    display_set(dp2, str(score["b"]))
                    if score["b"] == 7:
                        active = False
                        print("GAME_STOP")
                        score["b"] = 0
                        score["r"] = 0

                elif signal == "RSCORE" and active:
                    score["r"] += 1
                    display_set(dp1, str(score["r"]))
                    if score["r"] == 7:
                        active = False
                        print("GAME_STOP")
                        score["b"] = 0
                        score["r"] = 0

    except Exception: pass

    time.sleep(0.01)
