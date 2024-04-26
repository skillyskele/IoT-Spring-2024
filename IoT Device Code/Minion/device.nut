local udpsocket;
local interface;
local ucastIP;
local bcastIP;

local LEDstate = 1;
hardware.pin1.configure(DIGITAL_OUT, LEDstate);

LED <- hardware.pin5;
humidityPin <- hardware.pin2;

LED.configure(DIGITAL_OUT, 1);
humidityPin.configure(ANALOG_IN);

function readHumidity() {
    local reading = humidityPin.read();
    server.log("Humidity pin reading: " + reading);
    return reading
}
function toggleLED() {
    LEDstate += 1
    LED.write(LEDstate % 2)
    LEDstate = LEDstate % 2
    return LEDstate
}



//agent.on("readHumidity", readHumidityLoop)

//This section of the code is the UDP stuff!

function dataReceived(fromAddress, fromPort, toAddress, toPort, data) {
    // Check that we are the destination (unicast or broadcast)
    if (toAddress == ucastIP || toAddress == bcastIP) {
        // Log the receipt of data
        server.log("Received: " + data + "length: " + data.len() + "bytes from " + format("%s:%d", fromAddress, fromPort));

        data = data.tostring()
        if (data=="Humidity"){
            server.log("reading Humidity")
            data=readHumidity();
        } else if (data=="LED"){
            server.log("toggling LED")
            data=toggleLED();
        } else {
            server.log(data)
        }

        // Echo it back
        local result = udpsocket.send(fromAddress, fromPort, data.tostring());
        if (result != 0) server.error("Could not send the data (code: " + result + ")");
    }
}

function interfaceHandler(state) {
    if (state == imp.net.CONNECTED && udpsocket == null) {
        // Get the imp's IP and the network broadcast IP
        local ipData = interface.getiptable();
        ucastIP = ipData.ipv4.address;
        bcastIP = ipData.ipv4.broadcast;

        // Initiate UDP
        udpsocket = interface.openudp(dataReceived, 1234);
    }

    if (state == imp.net.ETHERNET_STOPPED ||
        state == imp.net.ETHERNET_STOPPED_UNHAPPY ||
        state == imp.net.ETHERNET_STOPPED_NO_LINK ) {
            server.error("Ethernet error - closing UDP");
            if (udpsocket != null) {
                udpsocket.close();
                udpsocket = null;
            }
    }
}
interface = imp.net.open({"interface":"wl0"}, interfaceHandler);
