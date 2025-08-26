# Fly MPG Proxy

Fly MPG Proxy enables you to connect to [Fly Managed Postgres](https://fly.io/docs/mpg/) from servers and service providers across the Internet.

[Fly Managed Postgres](https://fly.io/docs/mpg/) can only be connected to by machines on the Fly Network, or by clients using [flyctl](https://fly.io/docs/flyctl/).  Fly MPG Proxy changes that by providing a reverse proxy that can be accessed over the Internet and is managed just like any other Fly app.

## How to install Fly MPG Proxy

Installing Fly MPG Proxy is as easy to installing any other app on Fly!

### Clone this repository

```
git clone https://github.com/symkat/fly-mpg-proxy.git
cd fly-mpg-proxy
```

### Update fly.toml

First, follow these steps to find the Cluster ID for your MPG Cluster:

1. Go to the [Fly Dashboard](https://fly.io/dashboard/) and click *Managed Postgres*.
2. Click the name of your MPG Cluster.
3. Copy the *Cluster ID* value.

Secondly, update the value in `fly.toml`.

1.  Open `fly.toml` in your favorite text editor.
2.  Find the line `CLUSTER_ID = "YOUR-CLUSTER-ID-HERE"`.
3.  Replace `YOUR-CLUSTER-ID-HERE` with the Cluster ID you just copied.

Finally, update the region.

1.  In the same panel you found the Cluster ID, note the value of *Region*.
2.  Find the line `primary_region = 'lax'` and replace `lax` with the value of *Region*
3.  Note that the region should be lower-case in the config file.

Save the `fly.toml` file with these changes.

### Launch your application

Run `fly launch` to setup Fly MPG Proxy.

You will see the following prompt:

```
An existing fly.toml file was found for app fly-mpg-proxy
? Would you like to copy its configuration to the new app? (y/N)
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
Visit your newly deployed app at https://fly-mpg-proxy.fly.dev/
```

## How to Connect

Now that the Fly MPG Proxy is up and running, you can connect to it.

Get the Connection URL from the MPG Panel.

1. Go to the [Fly Dashboard](https://fly.io/dashboard/) and click *Managed Postgres*.
2. Click the name of your MPG Cluster.
3. Click *Connect*
4. Locate *Connect directly to your database* and click the Eye symbol on the right to reveal the password.
5. Copy the Connection URL, for example `postgresql://fly-user:password@direct.9g6y30w23lk0v5ml.flympg.net/fly-db`

Replace the hostname section of this connection URL, for example my URL is `direct.9g6y30w23lk0v5ml.flympg.net`, and I would replace that with `fly-mpg-proxy.fly.dev`.

Now I can connect with this Connection URL:

```
$ psql postgresql://fly-user:password@fly-mpg-proxy.fly.dev/fly-db
psql (17.6, server 16.8 - Percona Distribution)
Type "help" for help.
```

This will connect directly to the Postgres DB.  To connect to the PGBouncer Pool, connect on port `6432`:

```
$ psql postgresql://fly-user:password@fly-mpg-proxy.fly.dev:6432/fly-db
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

## Cheers!

Thanks for checking out this project!
