# Import required modules
import os
import shutil

# Define the directory path
dir_path = os.path.dirname(__file__)

# Define the edid-rw directory and files
edid_rw_dir = os.path.join(dir_path, 'edid-rw')

# Check if the edid-rw directory exists
if not os.path.exists(edid_rw_dir):
    # If not, create the directory
    os.makedirs(edid_rw_dir)

    # Copy the edid-rw executable to the directory
    shutil.copyfile('edid-rw', os.path.join(edid_rw_dir, 'edid-rw'))

    # Copy the edid-decode executable to the directory
    shutil.copyfile('edid-decode', os.path.join(edid_rw_dir, 'edid-decode'))