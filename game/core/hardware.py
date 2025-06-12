from gpiozero import Button
import pico
import core

def rscore():
    pico.send_signal("RSCORE")
    core.log("LOG", "Game", f"Red Scored, Score is now: {core.score["r"]}")
    core.score["r"] += 1
def bscore():
    pico.send_signal("BSCORE")
    core.log("LOG", "Game", f"Blue Scored, Score is now: {core.score["b"]}")
    core.score["b"] += 1


SwitchB = Button(15, bounce_time=0.05)  # GPIO on Pin 10, Ground on Pin 9
SwitchR = Button(21, bounce_time=0.05)  # GPIO on Pin 40, Ground on Pin 39

def switches(state):
    if state:
        SwitchB.when_pressed = bscore
        SwitchR.when_pressed = rscore
    else:
        SwitchB.when_pressed = None
        SwitchR.when_pressed = None
