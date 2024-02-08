# docker-nvchecker

Run nvchecker in a Docker container, with configuration files in a volume and a configurable UID/GID for said files.

[![](https://circleci.com/gh/wastrachan/docker-nvchecker.svg?style=svg)](https://circleci.com/gh/wastrachan/docker-nvchecker)
[![](https://img.shields.io/docker/pulls/wastrachan/nvchecker.svg)](https://hub.docker-nvchecker.com/r/wastrachan/nvchecker)

## Install

#### Docker Hub

Pull the latest image from Docker Hub:

```shell
docker pull wastrachan/nvchecker
```

#### Manually

Clone this repository, and run `make build` to build an image:

```shell
git clone https://github.com/wastrachan/docker-nvchecker.git
cd docker-nvchecker
make build
```

If you need to rebuild the image, run `make clean build`.

## Run

Run this image with the `make run` shortcut, or manually with `docker run`.

```shell
docker run -v "$(pwd)/config:/config" \
           --name nvchecker \
           --rm \
           -e PUID=1000 \
           -e PGID=1000 \
           wastrachan/nvchecker:latest
```

## Configuration

Configuration files are stored in the `/config` volume. You may wish to mount this volume as a local directory, as shown in the examples above.

#### Configuration Files

This README won't touch on the configuration specifics of nvchecker (check out the documentation [here](https://nvchecker.readthedocs.io/en/latest/usage.html#configuration-files)). In general, understand that running the container for the first time (`make run`) will create three files in your mounted config volume:

- `/config/nvchecker.toml` - The main nvchecker configuration file. Defines what sources should be checked when the container runs.
- `/config/new_ver.json` - The nvchecker "new version" file. When the container runs, _current_ published software versions are recorded in a JSON object in this file.
- `/config/old_ver.json` - The nvchecker "old version" file. When the container runs, current published software versions are compared with versions in this file. Changes are reported in stdout. When you have noted and acted on an updated release, you should record the version in the `old_ver.json` file.

#### User / Group Identifiers

If you'd like to override the UID and GID of the application, you can do so with the environment variables `PUID` and `PGID`. This is helpful if other containers must access your configuration volume.

#### Timezone

The timezone the container uses defaults to `UTC`, and can be overridden with the `TZ` environment variable.

#### Volumes

| Volume    | Description             |
| --------- | ----------------------- |
| `/config` | Configuration directory |

## License

The content of this project itself is licensed under the [MIT License](LICENSE).

[View license information for the software contained in this image.](https://github.com/lilydjwg/nvchecker/blob/master/LICENSE)
