# Persistent Data

https://hub.docker.com/r/sonatype/nexus3

There are two general approaches to handling persistent storage requirements with Docker. See Managing Data in Containers for additional information.

Use a docker volume. Since docker volumes are persistent, a volume can be created specifically for this purpose. This is the recommended approach.

```bash
docker volume create --name nexus-data
docker run -d -p 8081:8081 --name nexus -v nexus-data:/nexus-data sonatype/nexus3
```

Mount a host directory as the volume. This is not portable, as it relies on the directory existing with correct permissions on the host. However it can be useful in certain situations where this volume needs to be assigned to certain specific underlying storage.

```bash
mkdir /some/dir/nexus-data && chown -R 200 /some/dir/nexus-data
docker run -d -p 8081:8081 --name nexus -v /some/dir/nexus-data:/nexus-data sonatype/nexus3
```