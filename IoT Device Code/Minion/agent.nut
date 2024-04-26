function feedback() {
    server.log("Connected!")
    //device.send("readHumidity", 1.0)
}

device.onconnect(feedback)
