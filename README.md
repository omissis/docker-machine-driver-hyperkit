# docker-machine-driver-hyperkit

## Install

```shell
make build
make install
```

The hyperkit driver currently requires running as root to use the vmnet framework to setup networking.

## Usage

### Available flags

| Flag name                        | Environment variable           | Type   | Default                                                               |
|----------------------------------|--------------------------------|--------|-----------------------------------------------------------------------|
| `--hyperkit-boot2docker-url`        | `HYPERKIT_BOOT2DOCKER_URL`        | string | `$HOME/.docker/machine/cache/boot2docker.iso`                         |
| `--hyperkit-cpu-count`              | `HYPERKIT_CPU_COUNT`              | int    | `1`                                                                   |
| `--hyperkit-memory-size`            | `HYPERKIT_MEMORY_SIZE`            | int    | `1024`                                                                |
| `--hyperkit-disk-size`              | `HYPERKIT_DISK_SIZE`              | int    | `20000`                                                               |
| `--hyperkit-nfs-share`              | `HYPERKIT_NFS_SHARE`              | string | Path to a host folder to be shared inside the guest |                 |
| `--hyperkit-nfs-share-root`         | `HYPERKIT_NFS_SHARE_ROOT`         | string | root path at which the NFS shares will be mounted| `/hyperkit-nfsshares` |

#### `--hyperkit-boot2docker-url`

The URL(Path) of the boot2docker image.
By default, use cached iso file path.

#### `--hyperkit-cpu-count`

Number of CPUs to use the create the VM.
If set `-1`, use logical CPUs usable by the current process.

#### `--hyperkit-memory-size`

Size of memory for the guest.

#### `--hyperkit-disk-size`

Size of disk for the guest (MB).

#### `--hyperkit-nfs-share /path/to/host/folder`

Share `path/to/host/folder` inside the guest at the path specified by `--hyperkit-nfs-share-root` (which itself defaults to `/hyperkit-nfsshares`).

Can be specified multiple times

#### `--hyperkit-nfs-share-root /path`

By default, NFS Shares will be mounted in the Guest at `/hyperkit-nfsshares`.

You can change this default by specifying `--hyperkit-nfs-share-root /path`, `/path` being a path to the root