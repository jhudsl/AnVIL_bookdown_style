# Data modules

Modules aimed importing and managing data on AnVIL.
 
<br>
 
## Getting Data from HPC to AnVIL

:::: {.borrowed_chunk}

If you're used to working on High Performance Computing (HPC, or "on-premises" institutional servers) you'll likely need to transfer files from your HPC to AnVIL. You can check out [this Terra documentation](https://support.terra.bio/hc/en-us/articles/10206456029083-How-to-install-gcloud-on-a-local-machine) for the most recent information on installing Google Cloud SDK. There's also great documentation about moving data to/from Google buckets [here](https://support.terra.bio/hc/en-us/articles/4409101169051-How-to-move-data-to-from-a-Google-bucket).

You will need to:

1. Install Google Cloud SDK (`gcloud`) on your server

2. "Initialize" `glcoud` and authenticate with your Google account

3. Connect to your Workspace

4. Transfer files

**Step 1:** Install Google Cloud SDK on your server. This is software that enables file transfer. The code here is an example specifically for a Linux server. You might need to follow different instructions [depending on your server setup](https://cloud.google.com/sdk/docs/install).

```
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
tar -xf google-cloud-cli-linux-x86_64.tar.gz
google-cloud-sdk/install.sh
```

**Step 2:** Initialize `glcoud`. You might need to specify the path to the executable `gcloud`, e.g., `google-cloud-sdk/bin/gcloud init`.

```
gcloud init
```

You will be asked to copy and paste a long link in your browser. Enter the authorization code to confirm Google Cloud SDK access.

```
Go to the following link in your browser:

    https://accounts.google.com/o/oauth2/auth?response....
    
Enter authorization code:
```

**Step 3:** Connect to your Workspace. You will see a message like this:

```
This account has a lot of projects! Listing them all can take a while.
 [1] Enter a project ID
 [2] Create a new project
 [3] List projects
Please enter your numeric choice:
```

Select `1` to enter your Workspace's Google Project ID. You can find this by opening your Workspace and viewing the Dashboard tab. It will look something like `terra-123abcefg`. Confirm you are in the right place by typing in the following. The command should return the Bucket name.

```
gcloud storage ls
```

**Step 4:** Transfer files. Now you're ready to copy data over! Use the command below, replacing the `/data/user_name/data_folder` with the directory on your server, and replacing `gs://fc-a1b2c3` with your Bucket name. 

- You can find the Bucket name by entering `gcloud storage ls` or checking the Workspace and viewing the Dashboard tab.
- Note that the `-r` flag is "recursive", which means all files in that directory will be moved over. 

```
gcloud storage cp -r /data/user_name/data_folder gs://fc-a1b2c3
```
::::
