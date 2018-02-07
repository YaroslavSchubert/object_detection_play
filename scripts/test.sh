#!/bin/bash
PROJECTS_PATH=/home/yaroslav/Projects/
EXPERIMENT_PATH=/media/HDD/development/Lastivka_files/oxford_pets/experiments

# run from Tensorflow API folder
cd $PROJECTS_PATH/models/research
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim

# configuration
PROJECT_BASE=$PROJECTS_PATH/object_detection_play
EXPERIMENT_CONFIG=${PROJECT_BASE}/experiment.config
EXPERIMENT_TIMESTAMP_CONFIG=${PROJECT_BASE}/experiment.timestamp

# read experiment name & timestamp from file
source $EXPERIMENT_CONFIG
source $EXPERIMENT_TIMESTAMP_CONFIG
if [ -z "$experiment_name" ]; then
    echo "experiment_name is invalid; Value: ${experiment_name} "
fi
if [ -z "$experiment_timestamp" ]; then
    echo "experiment_timestamp is invalid; Value: ${experiment_timestamp} "
fi

EXPERIMENT_NAME_FULL=${experiment_name}_${experiment_timestamp}
PIPELINE_CONFIG=${PROJECT_BASE}/configuration/pipeline.config
CHECKPOINT=${EXPERIMENT_PATH}/${EXPERIMENT_NAME_FULL}/train/
EVAL_DIR=${EXPERIMENT_PATH}/${EXPERIMENT_NAME_FULL}/eval/

echo "Starting evaluation..."
echo "Pipeline config: " $PIPELINE_CONFIG
echo "Checkpoint path: " $CHECKPOINT
python object_detection/eval.py \
    --logtostderr \
    --pipeline_config_path=${PIPELINE_CONFIG} \
    --checkpoint_dir=${CHECKPOINT} \
    --eval_dir=${EVAL_DIR}
