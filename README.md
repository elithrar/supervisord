## silverlock/supervisord

A Docker image for running applications with the
[Supervisor](http://supervisord.org/) process monitor.

This image:

* Uses the `debian:jessie` base image
* Installs Supervisor from the Debian repositories
* Configures Supervisor to log to `/dev/stdout` so that Docker can process the
  logs
* Imports any configurations you add to `/etc/supervisor/conf.d/` - just extend
  the image and copy `yourapp.conf` there.
* Exposes port 9001 on the container so that you can monitor the application 
  uptime via `supervisorctl -s http://<container_ip>:<mapped_port>` on the host.

## Extending it?

Here's how to extend it with a simple example—a Go webserver container:

```go
# some-app
#
# VERSION       0.1.0
FROM silverlock/supervisor
MAINTAINER Matt Silverlock matt@eatsleeprepeat.net

# create a deploy user for our app to run as
RUN adduser --disabled-password --gecos "" deploy
RUN mkdir -p /home/deploy/some-app
 
# copy our supervisor config
COPY some-app.supervisord /etc/supervisor/conf.d/some-app.conf
 
# copy the Go binary
COPY some-app /home/deploy/

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

EXPOSE 8000
```

Our `/etc/supervisor/conf.d/some-app.conf` file looks like this:

```ini
[program:some-app]
user=deploy
directory=/home/deploy/
command=/home/deploy/some-app
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
```

Note the log re-direction to stdout (instead of inside the container) and the
use of `stdout_logfile_maxbytes=0` to prevent log-rotation, which won't work
when using stdout.

## LICENSE

BSD 3-Clause. See the LICENSE file for details.

