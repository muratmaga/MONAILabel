#!/bin/bash

#copy contents from the nnunet basefolder to monai

#set this path to the location of the nnunet path defined from yesterday
BASE=/home/exouser/Downloads/nnmouse/raw/Dataset001_mouse/

OUT=/home/exouser/MONAI/MyData

mkdir -p $OUT/labels/final
mkdir -p $OUT/labels/original


cp $BASE/imagesTr/* $OUT
cp $BASE/labelsTr/* $OUT/labels/final

