#!/bin/bash

# ASCII Art Header
cat << "EOF"
 ___________ ___________ _______   __  _____ _____ ______ ___________ _____ 
|_   _| ___ \  _  |  _  \_   _\ \ / / /  ___/  __ \| ___ \_   _| ___ \_   _|
  | | | |_/ / | | | | | | | |  \ V /  \ `--.| /  \/| |_/ / | | | |_/ / | |  
  | | |  __/| | | | | | | | |  /   \   `--. \ |    |    /  | | |  __/  | |  
 _| |_| |   \ \_/ / |/ / _| |_/ /^\ \ /\__/ / \__/\| |\ \ _| |_| |     | |  
 \___/\_|    \___/|___/  \___/\/   \/ \____/ \____/\_| \_|\___/\_|     \_/  
EOF

# Function to check and install required packages
check_and_install_dependencies() {
    local dependencies=("udisks2" "alsa-utils" "beep")
    local missing_dependencies=()

    for pkg in "${dependencies[@]}"; do
        if ! command -v "$pkg" &> /dev/null; then
            missing_dependencies+=("$pkg")
        fi
    done

    if [ ${#missing_dependencies[@]} -ne 0 ]; then
        echo "The following packages are missing: ${missing_dependencies[*]}"
        echo "Installing necessary packages..."
        sudo pacman -Syu --needed "${missing_dependencies[@]}"
    fi
}

# Check and install dependencies
check_and_install_dependencies

# Function to detect the specific iPod path
detect_ipod() {
    local ipod_mount="/run/media/fdiskzles/SMUGW_S IPO/"

    # Check if the iPod mount point exists
    if [ -d "$ipod_mount" ]; then
        echo "Detected iPod mounted at: $ipod_mount"
    else
        echo "No iPod or Apple devices detected. Please make sure your device is connected."
        exit 1
    fi
}

# Detect iPod
detect_ipod

# Define the iPod mount point
IPOD_MOUNT="/run/media/fdiskzles/SMUGW_S IPO/"

# Backup existing data (optional, uncomment to enable)
echo "Backing up existing data on iPod..."
# Uncomment and modify this line to back up existing data
# rsync -a "$IPOD_MOUNT/" /path/to/backup/directory/

# Format the iPod (Warning: This will erase all data)
echo "Formatting the iPod..."
sudo mkfs.vfat -I "$IPOD_MOUNT"  # Adjust filesystem type as necessary

# Download the minimal Linux root filesystem
echo "Downloading minimal Linux filesystem..."
wget -q -O "$IPOD_MOUNT/alpine-minirootfs.tar.gz" https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/x86_64/alpine-minirootfs-3.17.2-x86_64.tar.gz

# Check if the download was successful
if [ ! -f "$IPOD_MOUNT/alpine-minirootfs.tar.gz" ]; then
    echo "Error downloading the minimal Linux filesystem. Please check the link."
    exit 1
fi

# Create a directory to extract the downloaded filesystem
echo "Creating extraction directory..."
EXTRACTION_DIR="$IPOD_MOUNT/alpine-minirootfs"
mkdir -p "$EXTRACTION_DIR"

# Extract the downloaded filesystem
echo "Extracting Linux files..."
if sudo tar -xzf "$IPOD_MOUNT/alpine-minirootfs.tar.gz" -C "$EXTRACTION_DIR"; then
    echo "Extraction successful."
else
    echo "Error during extraction. Please check the tarball."
    exit 1
fi

# Clean up the downloaded file
sudo rm "$IPOD_MOUNT/alpine-minirootfs.tar.gz"

# Create a new root filesystem tarball from the current directory
echo "Creating root filesystem tarball..."
if sudo tar -zcpf "$IPOD_MOUNT/rootfs.tar.gz" -C "$EXTRACTION_DIR" .; then
    echo "Root filesystem tarball created successfully."
else
    echo "Error creating root filesystem tarball."
    exit 1
fi

# Install boot loader (like GRUB)
echo "Installing boot loader..."
# This may vary based on your bootloader requirements
# e.g., grub-install or other bootloader installation command

# Unmount the iPod
sudo umount "$IPOD_MOUNT"

# Reboot instructions
echo "Installation complete! Please reboot your iPod to start using Linux."
echo "Ensure you safely eject your iPod before disconnecting."
