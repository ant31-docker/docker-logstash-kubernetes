# docker-logstash-kubernetes

Logstash container for pulling docker logs with kubernetes metadata support.
Additionally logs are pulled from systemd journal too.

Logstash tails docker logs and extracts `pod`, `container_name`, `namespace`,
etc. The way this works is very simple. Logstash looks at an event field which
contains full path to kubelet created symlinks to docker container logs, and
extracts useful information from a symlink name. No access to Kubernetes API
is required.

/!\
Events are not pushed by default (no output).
You have to create a custom output. Either by creating a new image that include your configuration, or by running the container with the desired ouput as extra parameters.

## Requirements

You need to have kubelet process running on the host. Normally kubelet creates
symlinks to container logs from `/var/log/containers/` to
`/var/lib/docker/containers/`. So for that you need to make sure that logstash
has access to both directories.

For logstash to be able to pull logs from journal, you need to make sure that
logstash can read `/var/log/journal`.

Also, logstash writes `sincedb` file to its home directory, which by default is
`/var/lib/logstash`. If you don't want logstash to start reading docker or
journal logs from the beginning after a restart, make sure you mount
`/var/lib/logstash` somewhere on the host.

If you want to push events to Cloudwatch Logs, then you will have to set AWS
access keys via environment variables.


## Configuration

As usual, configuration is passed through environment variables.

### Logstash

- `LS_HEAP_SIZE` - logstash JVM heap size. Defaults to `500m`.

## Running

Tags are following logstash official image tags


```
$ docker run -ti --rm \
    -v /var/lib/logstash-kubernetes:/var/lib/logstash \
    -v /var/log/journal:/var/log/journal:ro \
    -v /var/lib/docker/containers:/var/lib/docker/containers \
    -v /var/log/containers:/var/log/containers \
    quay.io/ant31/kubernetes-logstash:1.5
```
