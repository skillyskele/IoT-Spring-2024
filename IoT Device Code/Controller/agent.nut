function requestHandler(request, response) {
//    server.log(request.body);
    try {
        //try to send "go" message to device
local htmlHeader = "<HTML><HEAD><TITLE>Device Controller</TITLE>";
local htmlStyle = "<STYLE>\nbody { font-family: Arial, sans-serif; }\na { color: #0077cc; text-decoration: none; }\na:hover { text-decoration: underline; }\n</STYLE></HEAD>";
local htmlStartBody = "<BODY><h1>Device Controller</h1><p><a href='" + http.agenturl() + "?Humidity'><strong>Read Humidity</strong></a></p>";
local htmlStopBody = "<p><a href='" + http.agenturl() + "?LED'><strong>Toggle LED</strong></a></p>";
local htmlEnding = "</BODY></HTML>";

local HTML = htmlHeader + htmlStyle + htmlStartBody + htmlStopBody + htmlEnding;



        response.send(200, HTML);
        
        if ("Humidity" in request.query) {
            device.send("Humidity", 0);
            return;
        } else if ("LED" in request.query) {
            device.send("LED", 0);
            return;
        } else if ("ARP" in request.query) {
            device.send("ARP", 0);
            return;
        }
    } catch (ex) {
        response.send(500, "Internal Server Error: " + ex);
    }
}

http.onrequest(requestHandler);