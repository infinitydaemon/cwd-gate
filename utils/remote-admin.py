import socket
import subprocess
import os

def execute_command(command):
    result = subprocess.run(command, stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE, shell=True)
    output = result.stdout.decode().strip()
    error = result.stderr.decode().strip()
    return output if output else error

def connect():
    host = input("Enter the IP address: ")
    port = int(input("Enter the port number: "))

    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    
    try:
        client_socket.connect((host, port))
        print(f"Connected to {host}:{port}")
        welcome_msg = client_socket.recv(1024).decode()
        print(welcome_msg)
        
        while True:
            command = input("> ")
            client_socket.send(command.encode())
            
            if command.lower() == 'exit':
                break
            
            output = client_socket.recv(1024).decode()
            print(output)
            
    except ConnectionRefusedError:
        print(f"Connection to {host}:{port} refused")
    except KeyboardInterrupt:
        print("\nExiting")
    finally:
        client_socket.close()

def start_server(port):
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind(('', port))
    server_socket.listen(1)
    print(f"Listening on port {port}")
    
    while True:
        client_socket, address = server_socket.accept()
        print(f"Accepted connection from {address[0]}:{address[1]}")
        welcome_msg = "Welcome to the gate shell\n"
        client_socket.send(welcome_msg.encode())
        
        while True:
            command = client_socket.recv(1024).decode()
            
            if command.lower() == 'exit':
                break
            output = execute_command(command)
            client_socket.send(output.encode())
        client_socket.close()
    server_socket.close()
