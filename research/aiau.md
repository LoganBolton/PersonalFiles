# Basic Set Up for aiau gpu cluster

aiau is still in beta testing, so there's a lot of jankiness to set everything up. This is what I did that actually worked. This set up is very bad and cursed but it **does** work!

# Basic Info to know 

## Login
To login:
- ssh ldb0046@gate.eng.auburn.edu
- then type in 'aiau'

## What is aiau
Logging in to aiau does **NOT** give you access to GPUs straight away. If you type ```nvidia-smi``` after logging into aiau, it will not work. This is expected behavior and fine.

The only way to use the GPUs is to either:
1) create an interactive node 
2) schedule a job with SLURM

# Setting up Environment

## Virtual Environment
Originally I used vanilla virtualenv to set everything up. This was a **very bad idea**. venv works in mysterious ways and sometimes it would break in unexpected ways. I **highly** recommend you use Conda. 

To install conda, use winget from their download page. 

https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh

# Slurm

## What is SLURM
SLURM is a job scheduler. You send it jobs and it runs them on the cluster. Alternatively, you can have an interactive node that is like running your code locally. It doesn't wait for other people and it just runs the code as soon as you press enter like how it is on your local machine. 

## Interactive node 
Run this to have a node to test that things are working as intended.
```
salloc -N1
srun --pty /bin/bash
```

If you close your laptop this node will automatically shut down and any code you are running will be ended.

## Creating a job 
Here's an example of a basic job that I created. Sourcing the .bashrc is probably very bad, but it fixed a bug I was having so whatever. 

"run_extract_features.sbatch" 20L, 437B                                                                                                                                                                                           16,21         All
```
#!/bin/bash
#SBATCH --job-name=extract_features
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=08:00:00
#SBATCH --gres=gpu:1                 # Request 1 GPU
#SBATCH --output=extract_features_%j.log
#SBATCH --error=extract_features_%j.err

env > env_output.log
source ~/.bashrc

# Activate your conda environment
conda activate llava2

# Run your Python script
python extract_features.py
```

to run this do ```sbatch run_extract_features.sbatch```


## Basic SLURM commands
- Check the status of your jobs by doing ```squeue```
- To kill a job do ```scancel {job_id}```
- To list current available nodes do ```scontrol show nodes```

# General advice
Technically you can just use a preinstalled python by loading it from the module ```source /linux_apps/python-v3.12/env```. I would **NOT** recommend doing this if you are trying to run any models because most of them are not using this version of python. Sourcing from the linux apps and then activating your conda env causes all sorts of silent bugs to appear and cause you pain. Just stick to installing python through only conda. 

## Bashrc
For whatever reason, I was having lots of issues with getting my PATH variables to work. I ended up having to change my .bashrc file to make it work. This is definitely cursed and shouldn't work, but it does! There's for sure a better way to do this, but it worked for me.

"~/.bashrc" 21L, 677B                                                                                                                                                                                                             1,1           All
```
 export PATH=$HOME/.local/bin:$PATH
 export CUDA_HOME=/cm/shared/cuda12.4/toolkit/12.4.1
 export PATH=$CUDA_HOME/bin:$PATH
 export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/u2/ldb0046/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/u2/ldb0046/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/u2/ldb0046/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/u2/ldb0046/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
```
