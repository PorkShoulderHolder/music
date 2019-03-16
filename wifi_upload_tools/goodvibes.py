import click
import socket
import json
from math import ceil

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
    maxsize = 1300  # 1.3 KB
    print("writing {} to {} as {}".format(filename, host, dest_filename))
    with open(filename) as f:
        file_data = f.read()
        chunks = [file_data[i * maxsize: (i + 1) * maxsize] for i in range(
            0, int(ceil(len(file_data) / maxsize)) + 1)]
        for i, c in enumerate(chunks):
            data = "cpfile{}:::{};;;{}".format(dest_filename,
                                               "{}/{}".format(i + 1,
                                                              len(chunks)),
                                               c)
            client.send(data)
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
@click.option("--repeat", default=None)
@click.option("--pattern", required=True)
def rhythm(host, tempo, repeat, pattern):
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
    doc = {"sequence": message}
    if repeat is not None:
        doc["repeat"] = int(repeat)
    msg = json.dumps(doc)
    client.send(msg)
    response = client.recv(4096)
    print(response)

if __name__ == '__main__':
    cli()
