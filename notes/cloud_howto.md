# AWS

1. image aanslingeren
2. ssh erin met pem file enzo
* goed overzicht van al die begin dingen https://medium.com/digitalcrafts/how-to-set-up-an-ec2-instance-with-github-node-js-and-postgresql-e363cb771826
* dit helpt ook https://aws.amazon.com/ec2/getting-started/
3. key maken, ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
4. 

# Google Cloud

## Create and access VM
1. Setup a machine

    a. Pick a type, e.g. the free f1-micro, and an OS, e.g. Ubuntu 18.10.

    b. Give it a name that you'll find useful in your ASV benchmark site, e.g. "gcloud-f1-micro-test2"
    
    c. Boot it up

2. [Install gcloud](https://cloud.google.com/sdk/downloads#interactive)
3. Connect to your VM using gcloud, copy paste the command from the drop-down menu that says "SSH" under Remote access, in my case:
    ```sh
    gcloud compute --project "ambient-sphere-225518" ssh --zone "us-east1-b" "gcloud-f1-micro-test2"
    ```
    First time you do this, it will authenticate your Google account, you may need Chrome installed for this (that's what gcloud started in my case).

## Configure VM
1. [Make a GitHub key](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/) so you can commit your benchmarks. To make life easier, add the following lines to your `~/.bashrc` or run them manually every time you want to commit to GitHub:
    ```sh
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/github_key
    ```
2. Install Miniconda
    ```sh
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh
    ```
    Pick everything on default, except the last question: enter yes to configure Bash for conda.
3. Close ssh connection and start new one (with `gcloud` again).
4. Install ASV and clone the benchmark repo:
    ```sh
    pip install asv
    git clone git@github.com:egpbos/barcode-asv.git
    ```

## Configure ASV with a first run
1. cd barcode-asv
2. asv run
    Now it will ask the machine name, just use the one you judiciously picked when creating the VM, because then you don't have to run `asv` with `--machine` option. Also just use defaults for the other metadata it asks for.
3. A normal run will also include a commit step. For this we need Git to be properly setup.
```sh
git config --global user.email "$USER@$HOSTNAME"
git config --global user.name "E. G. Patrick Bos"
```

## Normal ASV runs
All the above steps only have to performed once. After that, whenever you updated your code, log into the `gcloud` VM and run
```sh
barcode-asv/run_publish_upload.sh
```
The results can then be found at the [GitHub Pages site you set up for the repo](https://egpbos.github.io/barcode-asv/).


## Random experiences with Google Cloud

### VM
- With Google, you'll get a free VM for a year for 24/7 (f1-micro type, 10GB regular disk).
- New VMs are created and activated in less than a minute, pretty nice.
- Ubuntu 18.10 **Minimal** is really crappy. It is *really* minimal. It doesn't even have `vi`, so it isn't even fully POSIX compliant.
- Google recommends the `gcloud` tool for logging in to the VMs.

### ASV on Google Cloud
- On my first try running ASV on the f1-micro (on a Saturday evening, maybe that's a busy time?) it got stuck at the Creating environments stage, timing out after some waiting. I didn't encounter this problem anymore, but the possibility is something to take into account. Could be a problem with f1-micro, could be a timing/day of week issue, but whatever it is, it's a dependability issue.
- When debugging benchmarks (e.g. a failed status), use `asv run --verbose --show-stderr`. The last flag brought to light that my benchmark was hitting a timeout of 1 minute... So that had to be set higher, which was pretty hard to find in the docs (had to search the repo), but it's [here](https://asv.readthedocs.io/en/stable/writing_benchmarks.html#benchmark-attributes) and also [here](https://asv.readthedocs.io/en/stable/benchmarks.html).
- To get a reasonably stable measurement on the f1-micro, you need about 10 repeats, so using that now. May not be necessary on other machines though!
