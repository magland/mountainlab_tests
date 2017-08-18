#!/bin/bash

PATH0="MAGLAND_SIM001b"

mp-run-process mountainsort.synthesize_timeseries --firings=$PATH0/firings_true.mda --waveforms=$PATH0/waveforms_true.mda --waveforms_upsample_factor=13 --noise_level=1 --timeseries_out=data/raw.mda
