#!/usr/bin/env bash
# Télécharge PlantDoc (train/test) et PlantVillage (tomate uniquement, images couleur).
# Usage : bash download_data.sh
set -e

if [ ! -d PlantDoc-Dataset ]; then
  git clone --depth 1 https://github.com/pratikkayal/PlantDoc-Dataset.git
fi

if [ ! -d PlantVillage-Dataset ]; then
  git clone --depth 1 --filter=blob:none --sparse https://github.com/spMohanty/PlantVillage-Dataset.git
  (cd PlantVillage-Dataset && git sparse-checkout set --no-cone "raw/color/Tomato*")
fi

ls PlantVillage-Dataset/raw/color
ls PlantDoc-Dataset/train
