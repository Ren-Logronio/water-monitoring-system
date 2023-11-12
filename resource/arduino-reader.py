
from pyuac import main_requires_admin
import serial
import httpx
import time
import json

@main_requires_admin
def main():
    ser = serial.Serial('COM6', 9600)
    previous_line = ''
    while True:
        #slee[ for 1 second
        time.sleep(0.25)
        # read line from serial
        line = ser.readline().decode('utf-8').rstrip()
        if line == previous_line:
            # break for half second
            continue
        # parse to dictionary
        try:
            data = validate_and_convert(line)
            # add datetime to data using iso string format
            data['datetime'] = time.strftime('%Y-%m-%dT%H:%M:%S')
            #httpx post request
            r = httpx.post('http://localhost:80/water-monitoring/sensor/index.php', data=data)
            print(r.text)
            # store the line for the next iteration
            previous_line = line
        except ValueError as e:
            print(e)
            # next iteration
            continue

def validate_and_convert(string_data):
    # Check if the string has the expected format
    if not all(key in string_data for key in ['deviceid', 'name', 'ammonia', 'ph', 'temperature', 'sensors']):
        raise ValueError("String does not have the expected format")

    try:
        # Convert the string to a JSON-formatted string
        json_data = string_data.replace("'", "\"")  # Replace single quotes with double quotes
        json_data = json_data.rstrip()  # Remove trailing newline character
        json_data = json_data.rstrip(',')  # Remove trailing comma

        # Convert the JSON-formatted string to a dictionary
        dictionary_data = json.loads(json_data)
        
        # Check if the dictionary has all the required keys
        if not all(key in dictionary_data for key in ['deviceid', 'name', 'ammonia', 'ph', 'temperature', 'sensors']):
            raise ValueError("Dictionary does not have all the required keys")
        
        # Check if the values are of the expected type
        # deviceid is a string uuid, name is a string, ammonia is a 2 decimal double, ph is a 2 decimal double, temperature is a 2 decimal double
        if not isinstance(dictionary_data['deviceid'], str) or not isinstance(dictionary_data['sensors'], str) or not isinstance(dictionary_data['name'], str) or not is_float(dictionary_data['ammonia']) or not is_float(dictionary_data['ph']) or not is_float(dictionary_data['temperature']):
            raise ValueError("Dictionary values are not of the expected type")

        # Additional checks for the values if needed
        return dictionary_data
    
    except (json.JSONDecodeError, ValueError) as e:
        raise ValueError(f"Error while processing the string: {e}")
    
# Function to check if a string can be converted to a float
def is_float(value):
    try:
        float_value = float(value)
        return True
    except ValueError:
        return False

if __name__ == "__main__":
    main()
