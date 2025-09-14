# Fly MPG Proxy

Fly MPG Proxy enables you to connect to [Fly Managed Postgres](https://fly.io/docs/mpg/) from servers and service providers across the Internet.

[Fly Managed Postgres](https://fly.io/docs/mpg/) can only be connected to by machines on the Fly Network, or by clients using [flyctl](https://fly.io/docs/flyctl/).  Fly MPG Proxy changes that by providing a reverse proxy that can be accessed over the Internet and is managed just like any other Fly app.

## How to install Fly MPG Proxy

Installing Fly MPG Proxy is as easy as installing any other app on Fly!

Find the Cluster ID for your MPG Cluster by running `fly mpg list`.

Run the following commands:

```
mkdir mpg-proxy
cd mpg-proxy
fly launch --from=https://github.com/fly-apps/fly-mpg-proxy --secret CLUSTER_ID=Your-Cluster-ID
```

### Follow The Prompts

You will see the following prompt:


```
An existing fly.toml file was found
? Would you like to copy its configuration to the new app? y/N
```

Type `Y` and press `[Enter]`.

---

You will see information about the apps configuration and the following prompt:

```
? Do you want to tweak these settings before proceeding? (y/N)
```

Press `[Enter]`.

---

You will see a prompt asking to allocate a dedicated ipv4 and ipv6 address.


```
? Would you like to allocate dedicated ipv4 and ipv6 addresses now? (y/N)
```

Type `Y` and press `[Enter]`.

### Launched!

After these prompts, your app should be launched.  You'll see a message like the following:

```
Visit your newly deployed app at https://mpg-proxy-winter-flower-8923.fly.dev/
```

## How to Connect

Now that the Fly MPG Proxy is up and running, you can connect to it.

Get the Connection URL from the MPG Panel.

1. Go to the [Fly Dashboard](https://fly.io/dashboard/) and click *Managed Postgres*.
2. Click the name of your MPG Cluster.
3. Click *Connect*
4. Locate *Connect directly to your database* and click the Eye symbol on the right to reveal the password.
5. Copy the Connection URL, for example `postgresql://fly-user:password@direct.9g6y30w23lk0v5ml.flympg.net/fly-db`

Replace the hostname section of this connection URL, for example my URL is `direct.9g6y30w23lk0v5ml.flympg.net`, and I would replace that with `mpg-proxy-winter-flower-8923.fly.dev`.

Now I can connect with this Connection URL:

```
$ psql postgresql://fly-user:password@mpg-proxy-winter-flower-8923.fly.dev/fly-db
psql (17.6, server 16.8 - Percona Distribution)
Type "help" for help.
```

This will connect directly to the Postgres DB.  To connect to the PGBouncer Pool, connect on port `6432`:

```
$ psql postgresql://fly-user:password@mpg-proxy-winter-flower-8923.fly.dev:6432/fly-db
psql (17.6, server 16.8 - Percona Distribution)
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, compression: off, ALPN: none)
Type "help" for help.

fly-db=>
```

## IP Restrict Connections

In this default configuration, anyone on the Internet could connect to the Managed Postgres instance and try to guess the username and password to login.

Fly MPG Proxy can be configured so that only certain IP addresses can connect.

Open the file `ip-whitelist.txt` and add the IP addresses or CIDR notation for networks that you would like to be able to access the Fly Managed Postgres Cluster.  Make sure to comment out or remove the entries for `0.0.0.0/0` and `::0/0`.

Once you have this file populated with only the IP addresses and networks you would like to allow to connect, run `fly deploy` to update the server with your new whitelist.

## Support

MPG Proxy is a standalone application that you may install on fly.io to gain external access to MPG Clusters.  It is not a part of the Managed Postgres service and is not supported by fly.io.

## Cheers!

Thanks for checking out this project!
