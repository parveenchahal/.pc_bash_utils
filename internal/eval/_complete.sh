#!/usr/bin/env bash

complete -W "-c --confirmation -v --verbose" pbu.eval
complete -W "--lock_id --timeout" pbu.eval.with_lock