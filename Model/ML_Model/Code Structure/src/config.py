"""Configuration settings for the medical classifier."""

TFIDF_CONFIG = {
    'max_features': 10000,
    'ngram_range': (1, 3),
    'min_df': 2,
    'stop_words': 'english'
}

# CLASSIFIER_CONFIG = {
#     'n_estimators': 200,
#     'max_depth': 20,
#     'min_samples_split': 5,
#     'min_samples_leaf': 2,
#     'class_weight': 'balanced',
#     'random_state': 42
# }
CLASSIFIER_CONFIG = {
    'n_estimators': 300,  # Increase trees for better performance
    'max_depth': 25,  # Allow slightly deeper trees
    'min_samples_split': 3,  # Allow splitting smaller nodes
    'min_samples_leaf': 1,  # Allow smaller leaf nodes
    'class_weight': 'balanced_subsample',  # Adjust weights per bootstrapped sample
    'random_state': 42
}


TEST_SIZE = 0.2
VALIDATION_SIZE = 0.5