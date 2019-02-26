import click 
import socket
import json

TCPAPI_PORT = 3344


@click.group()
def cli():
    pass


@cli.command()
@click.argument("host")
@click.option("--filename", required=True)
@click.option("--dest-filename", default=None)
@click.option("--restart", is_flag=True)
def cp(host, filename, dest_filename, restart):
    if dest_filename is None:
        dest_filename = filename.split("/")[-1]
    hostname, port = host, TCPAPI_PORT
    client = socket.socket()
    client.connect((host, port))
    print("writing {} to {} as {}".format(filename, host, dest_filename))
    with open(filename) as f:
        file_data = f.read()
        data = {"filename": dest_filename, "data": file_data}
        if restart:
            data["restart"] = True
        client.send(json.dumps(data, encoding='utf-8'))
        response = client.recv(4096)
        print(response)


@cli.command()
@click.argument("host")
@click.argument("msg")
def send(host, msg):
    client = socket.socket()
    hostname, port = host, TCPAPI_PORT
    client.connect((host, port))
    client.send(msg)
    response = client.recv(4096)
    print(response)


@cli.command()
@click.argument("host")
@click.option("--tempo", default=100)
@click.option("--pattern", required=True)
def rhythm(host, tempo, pattern):
    client = socket.socket()
    hostname, port = host, TCPAPI_PORT
    client.connect((host, port))
    current_char = "_"
    message = {}
    for i, c in enumerate(pattern):
        if c != current_char and current_char != "_":
            message[str(i * tempo + 1)] = current_char + "1"
        if c != current_char and c == "l":
            message[str(i * tempo + 1)] = "l0"
        elif c != current_char and c == "r":
            message[str(i * tempo + 1)] = "r0"
        current_char = c

    msg = json.dumps({"sequence": message})
    print(msg)
    client.send(msg)
    response = client.recv(4096)
    print(response)

if __name__ == '__main__':
    cli()
