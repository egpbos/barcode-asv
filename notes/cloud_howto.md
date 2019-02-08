# AWS

1. image aanslingeren
2. ssh erin met pem file enzo
* goed overzicht van al die begin dingen https://medium.com/digitalcrafts/how-to-set-up-an-ec2-instance-with-github-node-js-and-postgresql-e363cb771826
* dit helpt ook https://aws.amazon.com/ec2/getting-started/
3. key maken, ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
4. 

# Google Cloud

## VM AANSLINGEREN
1. bij Google krijg je 1 jaar lang 24/7 gratis VM (f1-micro); eentje aangemaakt genaamd eerste-testje
NEXT TRY: new machine, gcloud-f1-micro-test; Ubuntu 18.10 Minimal (it creates and activates in less than a minute, quite nice)
NEXT TRY 2: Minimal is reaaally minimal, back to normal Ubuntu 18.10; gcloud-f1-micro-test2
2. om op je VM in te loggen is het volgens hen het handigst om de gcloud tool te gebruiken, dus ff installen https://cloud.google.com/sdk/downloads#interactive
3. verbinden via gcloud (https://cloud.google.com/compute/docs/instances/connecting-to-instance), daar moet je het commando voor hebben, die kun je krijgen uit het dropdown menuutje waar ssh op staat onder Remote access:
```sh
gcloud compute --project "ambient-sphere-225518" ssh --zone "us-east1-b" "eerste-testje"
```
Als je dat de eerste keer doet vraagt ie om je access in te stellen, aanwijzingen volgen dus. Daarvoor opent ie trouwens Chrome, dus mss moet je die wel geinstalleerd hebben...
NEXT TRY (2):
```sh
gcloud compute --project "ambient-sphere-225518" ssh --zone "us-east1-b" "gcloud-f1-micro-test2"
```


## SETUP
0. NEXT TRY: sudo apt-get install vim
NEXT TRY 2: never mind, that was for Minimal Ubuntu
1. GitHub key aanmaken zodat je benchmarks terug kunt committen
https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
Add to ~/.bashrc:
eval "$(ssh-agent -s)"

2. 
```sh
sudo apt-get install python-pip build-essential
```
And add to your .bashrc:
export PATH="${PATH}:${HOME}/.local/bin"

NEXT TRY:
```sh
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```
Everything on default, except the last question: enter yes to configure Bash for conda.
3. NEXT TRY: Close connection and start new one
4. pip install asv
5. git clone git@github.com:egpbos/barcode-asv.git

## FIRST ASV RUN (INCLUDES CONFIG)
1. cd barcode-asv
2. asv run
Now it will ask the machine name; I wanted to use gcloud_eerste-testje, which is not the hostname, which makes it necessary to use --machine gcloud_eerste-testje, which is annoying, so I just used eerste-testje. Lesson: name the gcloud VM well.
Just use defaults for all settings...
But in the end it turns out I need conda after all, since I used that as the depedency manager in my asv setup... d'oh! But this gives me nice opportunity to make a new VM and start over. Changes above marked "NEXT TRY:".

- When I initially tried this (Saturday evening) it got stuck at the Creating environments stage, timing out after some waiting. Now this is no longer a problem, but this is something to take into account. Could be a problem with f1-micro, could be a timing/day of week issue, but whatever it is, it's a dependability issue.

- For some reason my benchmarks had a failed status. When debugging, use asv run --verbose --show-stderr. The last flag brought to light that my benchmark was hitting a timeout of 1 minute... So that had to be set higher, which was pretty hard to find in the docs (had to search the repo), but it's here: https://asv.readthedocs.io/en/stable/writing_benchmarks.html#benchmark-attributes and also https://asv.readthedocs.io/en/stable/benchmarks.html

- To get a reasonably stable measurement on the f1-micro, you need about 10 repeats, so using that now. May not be necessary on other machines though!

## NORMAL RUN ASV
1. A normal run will also include a commit step. For this we need Git to be properly setup.
```sh
git config --global user.email "$USER@$HOSTNAME"
git config --global user.name "E. G. Patrick Bos"
```

2. Run with `barcode-asv/run_publish_upload.sh`