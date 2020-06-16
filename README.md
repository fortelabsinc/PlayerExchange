# PlayerExchange

The player exchange is a place where people can find help from other players of a game, etc

## Setting up for Local development

There are two ways to run a local development environment but this guide will focus on the
simpler version which does not require `Ansible`

### Required Local Installed

* [Elixir 1.10+](https://elixir-lang.org/install.html)
* [Docker Desktop](https://www.docker.com/products/docker-desktop)
* Python3

### Steps to setup a local environment

#### Setup Database and external servers

1. Open a terminal shell and got to the project root where you cloned the repo.  From now on this path will be referred to as `<project_root>`

1. `cd <project_root>/devops/local`

1. `docker-compose up`

1. Open a second terminal shell

1. `cd <project_root>/src && mix deps.get && mix deps.compile && cd apps/storage && ./setup.sh`

After these steps you should have all the databases running and setup

#### Launch the Application server

1. Open a terminal shell

1. `cd <project_root>/src`

1. Launch the server `iex -S mix`

#### Launch the Front End JS server

1. Open a terminal shell

1. `cd <project_root>/src/apps/gateway/client`

1. Launch the server `npm run serve`

After that can point your web browser to `http://localhost:4000/portal/client/v1/` and you should see the login page
