#!/bin/bash

mkdir data
rm MAGLAND_SIM001b/raw.mda

./synthesize_raw.sh

mp-run-process mountainsort.bandpass_filter --timeseries=data/raw.mda --timeseries_out=data/filt.mda --freq_max=6000 --freq_min=300 --freq_wid=1000 --quantization_unit=0 --samplerate=30000

mp-run-process mountainsort.whiten --timeseries=data/filt.mda --timeseries_out=data/pre.mda --quantization_unit=0

mp-run-process mountainsort.mountainsort3 --geom=MAGLAND_SIM001b/geom.csv --timeseries=data/pre.mda --firings_out=data/firings.mda --adjacency_radius=100 --clip_size=50 --consolidate_clusters=true --consolidation_factor=0.90000000000000002 --detect_interval=10 --detect_sign=0 --detect_threshold=3 --fit_stage=true --merge_across_channels=true --t1=-1 --t2=-1

mp-run-process mountainsort.compute_templates --firings=data/firings.mda --timeseries=data/filt.mda --templates_out=data/templates_filt.mda --clip_size=100 --clusters=

mp-run-process mountainsort.compute_templates --firings=data/firings.mda --timeseries=data/pre.mda --templates_out=data/templates_pre.mda --clip_size=100 --clusters=

mp-run-process mountainsort.cluster_metrics --firings=data/firings.mda --timeseries=data/pre.mda --cluster_metrics_out=data/cluster_metrics_1.json --samplerate=30000

mp-run-process mountainsort.isolation_metrics --firings=data/firings.mda --timeseries=data/pre.mda --metrics_out=data/cluster_metrics_2.json --pair_metrics_out= --compute_bursting_parents=false

mp-run-process mountainsort.combine_cluster_metrics --metrics_list=data/cluster_metrics_1.json --metrics_list=data/cluster_metrics_2.json --metrics_out=data/cluster_metrics.json

mp-run-process mountainsort.run_metrics_script --metrics=data/cluster_metrics.json --script=example_annotation.script --metrics_out=data/cluster_metrics_annotated.json

if ! [[ "$1" == "nogui" ]]; then
mountainview --raw=data/raw.mda --filt=data/filt.mda --pre=data/pre.mda --firings=data/firings.mda --samplerate=30000 --cluster_metrics=data/cluster_metrics_annotated.json
fi
