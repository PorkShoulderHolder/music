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


if __name__ == '__main__':
    cli()
