#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"

cp "$script_dir/../config/.gitconfig" ~/

