from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

# Target device details
TARGET_IP = "192.168.0.110"
TARGET_PORT = 1234

# Hardcoded username and password
USERNAME = "TrustedUser"
PASSWORD = "password"

@app.route('/')
def login_page():
    return render_template('login.html')

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    
    if username == USERNAME and password == PASSWORD:
        return redirect(url_for('index'))
    else:
        return render_template('login.html', message="Invalid credentials")

@app.route('/index')
def index():
    return render_template('index.html')

@app.route('/send', methods=['POST'])
def send():
    command = request.form['command']
    
    if command == "LED":
        response = send_udp("LED")
    elif command == "Humidity":
        response = send_udp("Humidity")
    
    return render_template('control_panel.html', message=f"Sent command: {command}", response=response.decode())

def send_udp(message):
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
        s.sendto(message.encode(), (TARGET_IP, TARGET_PORT))
        data, addr = s.recvfrom(1024)  # Receive data (assuming the response is not more than 1024 bytes)
        return data

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
