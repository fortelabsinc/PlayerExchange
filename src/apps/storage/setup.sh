#!/bin/bash

# Setup the Database in CockroachDB
mix ecto.create

mix ecto.gen.migration users
mix ecto.gen.migration postings

# Deploy any changes
mix ecto.migrate