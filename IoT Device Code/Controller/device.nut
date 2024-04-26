local udpsocket;
local interface;
local ucastIP;
local bcastIP;


function readHumidity(option) {
    server.log("Humidity");
    local data = "Humidity";
    local encodedData = data
    local result = udpsocket.send("192.168.0.110", 1234, encodedData);
}

function toggleLED(option) {
    local data = "LED";
    local encodedData = data
    local result = udpsocket.send("192.168.0.110", 1234, encodedData);
}


function dataReceived(fromAddress, fromPort, toAddress, toPort, data) {//fornow,itjustechoes
    // Check that we are the destination (unicast or broadcast)
    //if (toAddress == ucastIP || toAddress == bcastIP) {
        // Log the receipt of data
        server.log("Received: " + data + " length: " + data.len() + " bytes from " + format("%s:%d", fromAddress, fromPort));
    
    //}
}

function interfaceHandler(state) {
    if (state == imp.net.CONNECTED && udpsocket == null) {
        // We're connected, so initiate UDP
        local ipData = interface.getiptable();
        ucastIP = ipData.ipv4.address;
        bcastIP = ipData.ipv4.broadcast;
        udpsocket = interface.openudp(dataReceived, 1234); //you can make thissocket 2way by replacing null with a function that handles to, from and data
    }
}

interface = imp.net.open({"interface":"wl0"}, interfaceHandler);





agent.on("Humidity", readHumidity);
agent.on("LED", toggleLED);