#!/bin/bash
export CUDA_VISIBLE_DEVICES=0,1
DEVICE=0
FIXMATCH_FOLDER="$HOME/project/SSLRS/"
SAVE_LOCATION="/scratch/fixmatch_results/runs_new_paper_version/" #Where tensorboard output will be written
SAVE_NAME="weight_decay"
DATASET=aid #Dataset to use: Options are eurosat_ms, eurosat_rgb, aid, ucm
NET=efficientnet-b2 #Options are wideResNet,efficientnet-b0, efficientnet-b1, efficientnet-b2, efficientnet-b3, efficientnet-b4, efficientnet-b5,...  
NUM_LABELS=250
UNLABELED_RATIO=4
BATCH_SIZE=16
N_EPOCH=500                    #Set NUM_TRAIN_ITER = N_EPOCH * NUM_EVAL_ITER * 32 / BATCH_SIZE
NUM_EVAL_ITER=1000            #Number of iterations 
NUM_TRAIN_ITER=$(($N_EPOCH * $NUM_EVAL_ITER * 32/ BATCH_SIZE))
SEED=0
LR=0.03
RED='\033[0;31m'
BLACK='\033[0m'

#create save location
mkdir -p $SAVE_LOCATION

#switch to fixmatch folder for execution
cd $FIXMATCH_FOLDER
echo -e "Using GPU ${RED} $CUDA_VISIBLE_DEVICES ${BLACK}."

for WEIGHT_DECAY in 0.00005 0.000075 0.0001 0.00025 0.0005 0.00075 0.001; do
	#Remove "echo" to launch the script.
	echo python train.py --weight_decay $WEIGHT_DECAY --rank 0 --gpu $DEVICE --lr $LR --batch_size $BATCH_SIZE --num_train_iter $NUM_TRAIN_ITER --num_eval_iter $NUM_EVAL_ITER --num_labels $NUM_LABELS --save_name $SAVE_NAME --save_dir $SAVE_LOCATION --dataset $DATASET --net $NET --seed $SEED --uratio $UNLABELED_RATIO
	wait
done
