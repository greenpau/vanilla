# vanilla

Docker image with sshd and caddy

## Getting Started

Building the image:

```
docker build -t greenpau/vanilla .
```

Running the image:

```
docker stop vanilla1; docker rm vanilla1
docker run -d -i -t --name=vanilla1 --net=host greenpau/vanilla
docker logs vanilla1
```

Connecting to SSH server:

```
ssh -i app/id_rsa -p 2222 root@localhost
```

Connecting to Caddy:

```
curl localhost:2280/
```

## Reference

Create an archive for `caddy`:

```
cd app/ && cp /usr/bin/caddy .
tar -cvzf caddy.tar.gz ./caddy
rm -rf ./caddy
```

Generate SSH keys:

```
ssh-keygen -f ./app/ssh_host_ecdsa_key -N '' -t ecdsa -C=''
ssh-keygen -f ./app/ssh_host_rsa_key -N '' -t rsa -C=''
ssh-keygen -f ./app/ssh_host_ed25519_key -N '' -t ed25519 -C=''
ssh-keygen -f ./app/id_rsa -t rsa -b 4096 -N '' -C=''
```
