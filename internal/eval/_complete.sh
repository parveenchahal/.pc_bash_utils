#!/usr/bin/env bash

complete -W "-c --confirmation -v --verbose --serialized_args" pbu.eval
complete -W "--lock_id --timeout" pbu.eval.with_lock