from serial import Serial
from time import time, sleep

Serial = Serial(port="/dev/ttyACM0", baudrate=115200, timeout=1)


def handshake():
    Serial.write(("REQ_HANDSHAKE" + '\n').encode('utf-8'))

    start_time = time()

    while time() - start_time < 5:
        if Serial.in_waiting > 0:
            response = Serial.readline().decode('utf-8').strip()
            if response == "ACK_HANDSHAKE":
                return True
        sleep(0.1)

    return False

def send_signal(signal):
    Serial.write((signal + '\n').encode('utf-8'))

def wait_signal(signal):
    while True:
        if Serial.in_waiting > 0:
            response = Serial.readline().decode('utf-8').strip()
            if response == signal:
                return True
        sleep(0.1)
