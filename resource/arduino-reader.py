
from pyuac import main_requires_admin
import serial
import httpx
import time

@main_requires_admin
def main():
    ser = serial.Serial('COM6', 9600)
    while True:
        #slee[ for 1 second
        time.sleep(1)
        # read line from serial
        line = ser.readline().decode('utf-8').rstrip()
        #httpx post request
        r = httpx.post('http://localhost:80/water-monitoring/sensor/index.php', data={'temperature': line})
        print(r.text)

if __name__ == "__main__":
    main()
