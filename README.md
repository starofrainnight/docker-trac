# docker-trac

## How to run

```
docker run -it --rm  -p 80:80 -v /srv/trac:/srv/trac starofrainnight/trac
```

## Manage trac

For enter trac environment, you could invoke (bypass the entrypoint and enter bash shell):

```
docker run -it --rm -v /srv/trac:/srv/trac --entrypoint bash starofrainnight/trac
```
