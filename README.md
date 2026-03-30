# Employee Attrition Predictor - ML Pipeline

> End-to-end Data Science project predicting employee attrition using a
> blending ensemble with SHAP explainability, validated across 3 industries.

## Key Results

- **OOF AUC: 0.77** - honest 10-fold cross-validation, never inflated on training data
- **Cross-industry validation**: Generalised to 14,999-employee service sector (AUC 0.63)
  and 6,284-employee manufacturing firm (AUC 0.66) without retraining
- **Top SHAP driver**: Overtime employees leave at 3x the rate of non-overtime employees
- **Business impact**: Cost-optimized threshold saves $5.5M vs default 0.5 classifier

## Pipeline
```
Raw Data (1,470 employees, 35 features)
    |
Boruta + RFECV feature selection  ->  33 features reduced to 7
    |
Optuna-tuned base models (80 trials each)
    LightGBM + GradientBoosting + RandomForest
    |
OOF blending ensemble  ->  AUC-weighted combination
    |
Isotonic probability calibration
    |
Business cost-matrix threshold optimization
    |
SHAP explainability  ->  4 plot types
    |
Cross-dataset testing  ->  3 industries, 22K+ employees
```

## Model Comparison (honest numbers)

| Model | AUC | Evaluation Method |
|-------|-----|-------------------|
| Basic RF (Notebook 02) | ~0.85 | Training data - overfit, not reliable |
| Stacking (Notebook 02b) | ~0.88 | Training data - overfit, not reliable |
| OOF Blend (Notebook 06) | **0.77** | 10-fold OOF - honest |
| HR Analytics external | 0.63 | 14,999 unseen employees |
| MFG external | 0.66 | 6,284 unseen employees |

## Tech Stack

| Tool | Purpose |
|------|---------|
| LightGBM, sklearn | Base models |
| Optuna | Bayesian hyperparameter tuning |
| Boruta, RFECV | Two-stage feature selection |
| SHAP | Model explainability |
| PyTorch-TabNet | Neural network baseline |
| pandas, numpy | Data manipulation |

## Notebooks (run in order)

| Notebook | What it does |
|----------|-------------|
| 02_Week2_Modelling | Basic RF + SHAP baseline |
| 02b_Advanced_Model | Stacking ensemble |
| 04_Final_Pipeline | Boruta + OOF blend + calibration |
| 05_Test_And_Improve | Holdout testing + synthetic data |
| 06_Improved_Model | Final model with 3 fixes applied |
| 07_Cross_Dataset_Testing | External dataset validation |

## Dataset

IBM HR Analytics Employee Attrition
- Source: https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset
- 1,470 employees, 35 features, 16.1% attrition rate

External validation:
- HR Analytics 14K: https://www.kaggle.com/datasets/giripujar/hr-analytics
- MFG Termination: https://www.kaggle.com/datasets/HRAnalyticRepository/employee-attrition-data

## How to Run
```bash
conda create -n attrition python=3.10 -y
conda activate attrition
pip install pandas numpy scikit-learn lightgbm shap optuna matplotlib
pip install imbalanced-learn boruta pytorch-tabnet joblib
```

Download IBM dataset from Kaggle -> place in /data folder -> run notebooks in order.

