# How to train your own multilabel segmentation model with MonaiLabel

These instructions are meant to be run on a Ubuntu 22.04 image with direct GPU rendering setup on a JetStream GPU node (XXL flavor). Make sure you create the instance with at least 200GB of storage (by default, the boot image is only 60GB, with only about 40GB of available space. Docker and necessary NVIDIA drivers are already provided with the base image. If you try to this on a different VM image, you will have to install and configure those too (which are not covered here)

## Prerequisites
1. Setup your working directory for MONAILabel apps. 
   Open a terminal window and type
   ```
   mkdir -p /home/exouser/MONAI/myData
   ```
2. Upload your dataset to your JS2 instance. For this tutorial dataset is already provided to you under
   `/home/exouser/sample_data_MONAI`
3. MonaiLabel expects the data to be structured in a specific way. The volume files (grayscale images) will be at the top level of your data folder. At the same level as grayscale image there will be one more folder `labels/` in which there will be two sub-folders `original/` and `final/`. Originals will be empty. `final/` folder will contain the manually segmented labelmaps (e.g., training data). It is crucial that the grayscale volumes and their segmentations have identical file names. Assuming your dataset is called ```myData```, these commands will create the necessary folder structure under `/home/exouser/MONAI/Data`:
   ```
   mkdir -p /home/exouser/MONAI/myData/labels/final
   mkdir /home/exouser/MONAI/myData/labels/originals
   ```
4. Copy the contents sample data folder of the `grayscale/` to `myData/`
```
cp /home/exouser/sample_data_MONAI/grayscale/* /home/exouser/MONAI/myData/
```
5. Copy the contents sample data folder of the `labelmaps/` folder to `myData/labels/final/`
```
cp /home/exouser/sample_data_MONAI/labelmaps/* /home/exouser/MONAI/myData/labels/final/
```

6. **Install MonaiLabel via docker**. the command below assumes you have created the directory structure from step #1. (first create a new terminal window, and then execute the command below). 

```
docker run -it --rm --gpus all --ipc=host --net=host -v /home/exouser/MONAI:/workspace/ projectmonai/monailabel:latest bash
```
**NOTE:** Docker is a virtual environment isolated from the host computer you are using. `-v` or `--volumes` command above maps the contents of the specified host folder (in this case `/home/exouser/MONAI/`) as a different folder (in this case `/workspace') inside the docker environment. All the commands below to invoke the monailabel is run inside the docker, and hence uses the docker folder reference:

7. Obtain the radiology deepedit app
    ```monailabel apps --download --name radiology --output /workspace/```
8. Edit the contents of the '/workspace/radiology/lib/configs/deepedit.py` to match the label indices and names you used in your segmentation. For your convenience, an edited example script is already already provided for you. In your original terminal window use the command ```cp /home/exouser/sample_data_MONAI/deepedit.py /home/exouser/MONAI/radiology/lib/configs/deepedit.py```
    If you get an error message, it is likely that step #9 has not completed successfully for some reason.
 
9. You are now ready to launch the monailabel server and start the training using the Slicer extension
```monailabel start_server --app /workspace/radiology/ --studies /workspace/myData/ --conf models deepedit```

10. Download and uncompress Slicer (use stable 5.4.0)
```
tar zxvf /home/exouser/Downloads/Slicer-5.4.0-linux-amd64.tar.gz
```
11. Run Slicer
```
/home/exosuer/Downloads/Slicer-5.4.0-linux-amd64/Slicer
```
    and then go to the extenion manager and install MonaiLabel extension 
