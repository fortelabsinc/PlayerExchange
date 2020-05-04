#!/bin/bash

# Setup the Database in CockroachDB
mix ecto.create

mix ecto.gen.migration users
mix ecto.gen.migration postings
mix ecto.gen.migration xrp
mix ecto.gen.migration games

# Deploy any changes
mix ecto.migrate