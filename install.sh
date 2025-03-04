#!/usr/bin/env bash
set -e  # Exit immediately if a command exits with a non-zero status

# --- Clone or Update Repository ---
if [ ! -d "docetl-azure" ]; then
  echo "Cloning docetl-azure repository..."
  git clone git@github.com:thirdwishgroupai/docetl-azure.git
else
  echo "docetl-azure repository already exists. Pulling latest changes..."
  cd docetl-azure && git pull && cd ..
fi

# --- Create Virtual Environment ---
if [ ! -d "venv" ]; then
  echo "Creating Python virtual environment..."
  python3 -m venv venv
else
  echo "Virtual environment already exists."
fi

# --- Activate Virtual Environment ---
echo "Activating virtual environment..."
source venv/bin/activate

# --- Install Requirements from the Repository ---
echo "Installing requirements from docetl-azure..."
cd docetl-azure
pip install -r requirements.txt
cd ..

echo "Installing docetl==0.2.1 (this will override the previous version)..."
pip install docetl==0.2.1

# --- Locate the docetl Package Directory ---
PYTHON_VERSION=$(python -c 'import sys; print("python{}.{}".format(sys.version_info[0], sys.version_info[1]))')
DOCETL_PATH="venv/lib/$PYTHON_VERSION/site-packages/docetl"

if [ ! -d "$DOCETL_PATH" ]; then
  echo "Error: docetl package directory not found at $DOCETL_PATH. Exiting."
  exit 1
fi

# --- Overwrite Installed docetl with Repository Files ---
echo "Clearing existing files in the docetl package directory..."
rm -rf "$DOCETL_PATH"/*
echo "Copying files from docetl-azure to the docetl package directory..."
cp -r docetl-azure/* "$DOCETL_PATH"

echo "Installation complete."

