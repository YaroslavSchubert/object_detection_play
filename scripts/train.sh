#!/bin/bash
PROJECTS_PATH=/home/yaroslav/Projects
EXPERIMENT_RESULT_PATH=/media/HDD/development/Lastivka_files/oxford_pets/experiments

# run from Tensorflow API folder
cd $PROJECTS_PATH/models/research
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim

# configuration
PROJECT_BASE=$PROJECTS_PATH/object_detection_play
EXPERIMENT_CONFIG=${PROJECT_BASE}/experiment.config
EXPERIMENT_TIMESTAMP_CONFIG=${PROJECT_BASE}/experiment.timestamp

# read experiment name from file
source $EXPERIMENT_CONFIG
if [ -z "$experiment_name" ]; then
    echo "experiment_name is invalid; Value: ${experiment_name}"
    exit -1
fi

# Generate experiment timestamp
timestamp="experiment_timestamp="$(date -u +%s%N | cut -b1-13)
# write timestamp to config
if [ -f "$EXPERIMENT_TIMESTAMP_CONFIG" ]; then 
    echo "$timestamp" > "$EXPERIMENT_TIMESTAMP_CONFIG"
else
    echo "Couldn't write timestamp to config;"
    exit -1
fi

# check experiment timestamp
source $EXPERIMENT_TIMESTAMP_CONFIG
if [ -z "$experiment_timestamp" ]; then
    echo "experiment_timestamp is invalid; Value: ${experiment_timestamp} "
    exit -1
fi

# configuration
PIPELINE_CONFIG=${PROJECT_BASE}/configuration/pipeline.config
EXPERIMENT_NAME_FULL=${experiment_name}_${experiment_timestamp}

echo "Starting training..."
echo "Pipeline config: " $PIPELINE_CONFIG
echo "Experiment name: " $EXPERIMENT_NAME_FULL
# run training
python object_detection/train.py \
    --logtostderr \
    --pipeline_config_path=${PIPELINE_CONFIG} \
    --train_dir=${EXPERIMENT_RESULT_PATH}/${EXPERIMENT_NAME_FULL}/train
