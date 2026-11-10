# Détection des maladies de la tomate par CNN : du laboratoire au terrain

Projet de fin de module Deep Learning (cohorte 3 AI hub). Groupe : [NOMS DES MEMBRES]

Classifieur de maladies foliaires de la tomate (8 classes) à base de réseaux de neurones convolutifs, entraîné from scratch. Le but principal est de mesurer et de réduire l'écart entre des photos de laboratoire (**PlantVillage**) et des photos de terrain (**PlantDoc**).

## Contenu du dépôt

| Fichier | Rôle |
|---|---|
| `projet_cnn_maladies_tomate.ipynb` | Notebook complet et reproductible (téléchargement, split, MLP, CNN, robustesse, erreurs, Grad-CAM) |
| `fiche_impact.pdf` | Fiche d'impact (1 page) |
| `rapport_projet_cnn_tomate.pdf` | Rapport technique |
| `download_data.sh` | Script de téléchargement des données (équivalent de la cellule 1 du notebook) |
| `resultats.csv` | Tableau de résultats généré par le notebook |

## Exécution

1. Ouvrir `projet_cnn_maladies_tomate.ipynb` dans **Google Colab** (ou Kaggle).
2. Activer le GPU : *Exécution > Modifier le type d'exécution > GPU*.
3. Lancer **Exécution > Tout exécuter**. Le notebook télécharge lui-même les données, sans compte ni clé API :
   - PlantDoc : `git clone https://github.com/pratikkayal/PlantDoc-Dataset.git`
   - PlantVillage (tomate uniquement) : `git clone` avec `sparse-checkout` de `https://github.com/spMohanty/PlantVillage-Dataset.git`
4. Durée indicative : quelques minutes sur GPU Colab (environ 2 s par époque).

**Sur Kaggle** : ajouter les deux jeux avec *Add Data* et adapter `PV_ROOT`, `PD_TRAIN` et `PD_TEST` dans la cellule 2.

Si un chemin du dépôt a changé, vérifier avec `!ls` et adapter ces trois variables.

## Protocole

- **Culture** : tomate. Classes communes aux deux jeux (la « target spot » et les acariens sont exclus : absents de l'intersection des jeux).
- **Images** : redimensionnées en 64×64.
- **Split** : PlantVillage 70/15/15 stratifié après dédoublonnage ; PlantDoc : split officiel, 20 % du train mis en validation. Le test PlantDoc n'est jamais utilisé pour entraîner ni pour choisir un modèle.
- **Modèles** : MLP (baseline), CNN-A (sans batch norm), CNN-B (avec batch norm), CNN-C (2 blocs).
- **Stratégies de robustesse** : augmentation, augmentation + changement de fond, fine-tuning sur PlantDoc, entraînement mixte PlantVillage + PlantDoc.
- **Métriques** : précision, rappel et F1 par classe ; F1 macro comme métrique principale ; taux de « maladie ratée » (feuille malade classée saine). L'accuracy n'est pas utilisée comme critère de conclusion.
- **Reproductibilité** : graine fixée (`SEED = 42`). Les résultats peuvent varier légèrement selon le GPU.

## Résultats

| Modèle | F1 macro PlantVillage | F1 macro PlantDoc |
|---|---|---|
| MLP | 0,508 | 0,059 |
| CNN-A (sans BN) | 0,872 | 0,167 |
| CNN-B (BN) | 0,730 | 0,154 |
| CNN-C (BN, 2 blocs) | 0,673 | 0,183 |
| S1 Augmentation | 0,720 | 0,112 |
| S2 Augmentation + fond | 0,767 | 0,228 |
| S3 Fine-tuning sur PlantDoc | 0,647 | 0,310 |
| S4 Entraînement mixte | 0,784 | 0,267 |

Le modèle entraîné sur PlantVillage seul s'effondre sur le terrain (F1 macro 0,87 → 0,17). Test PlantDoc : 69 images, une seule graine : les écarts entre stratégies sont à interpréter avec prudence. Détails dans le rapport.

## Limites

PlantDoc est petit ; résolution réduite à 64×64 ; fuite possible dans PlantVillage (plusieurs photos d'une même feuille) ; changement de fond approximatif ; une seule graine ; aucune validation sur des photos de smartphone d'agriculteurs.

## Données et licences

PlantVillage et PlantDoc appartiennent à leurs auteurs respectifs ; se référer à leurs dépôts pour les conditions d'utilisation. Les images ne sont pas redistribuées dans ce dépôt.
