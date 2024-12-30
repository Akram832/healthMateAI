"""Handle data loading and preparation."""
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.utils import resample
from preprocessor import preprocess_text
from config import TEST_SIZE
import random


def augment_text(text, num_augmentations=3):
    """Simple text augmentation by shuffling words or adding noise."""
    augmented_texts = []
    words = text.split()
    for _ in range(num_augmentations):
        # Shuffle words randomly
        random.shuffle(words)
        augmented_text = ' '.join(words)
        augmented_texts.append(augmented_text)
    return augmented_texts



def validate_data(df):
    """Validate and augment dataset to handle rare classes."""
    # Count samples per class
    class_counts = df['label_text'].value_counts()
    
    # Identify rare classes
    rare_classes = class_counts[class_counts < 5].index  # Classes with <5 samples
    augmented_rows = []

    for rare_class in rare_classes:
        rare_samples = df[df['label_text'] == rare_class]
        
        for _, row in rare_samples.iterrows():
            augmented_texts = augment_text(row['text'])
            for text in augmented_texts:
                augmented_rows.append({'text': text, 'label_text': rare_class})
    
    # Create augmented DataFrame and combine with the original data
    augmented_df = pd.DataFrame(augmented_rows)
    df = pd.concat([df, augmented_df], ignore_index=True)

    print(f"Augmented {len(augmented_rows)} samples for rare classes.")
    return df





# def validate_data(df):
#     """Validate and clean dataset."""
#     # Count samples per class
#     class_counts = df['label_text'].value_counts()
    
#     # Filter out classes with less than 2 samples
#     valid_classes = class_counts[class_counts >= 2].index
#     df_filtered = df[df['label_text'].isin(valid_classes)]
    
#     if len(df_filtered) < len(df):
#         print(f"Removed {len(df) - len(df_filtered)} samples from classes with insufficient data")
    
#     return df_filtered





# def validate_data(df):
#     """Validate and clean dataset, handle rare classes."""
#     # Count samples per class
#     class_counts = df['label_text'].value_counts()
    
#     # Handle rare classes
#     rare_classes = class_counts[class_counts < 5].index  # Adjust threshold as needed
#     if len(rare_classes) > 0:
#         print(f"Handling {len(rare_classes)} rare classes.")
        
#         # Resample rare classes
#         rare_samples = df[df['label_text'].isin(rare_classes)]
#         augmented_rare_samples = resample(
#             rare_samples,
#             replace=True,  # Bootstrap sampling
#             n_samples=5 * len(rare_samples),  # Augment to a minimum of 5 samples per class
#             random_state=42
#         )
#         # Append augmented samples
#         df = pd.concat([df, augmented_rare_samples])
    
#     return df




def prepare_datasets(data_path):
    """Load and split dataset into train and test sets."""
    try:
        # Load data
        df = pd.read_csv(data_path)
        
        # Preprocess text
        df['text'] = df['text'].apply(preprocess_text)
        
        # Validate and filter data
        df = validate_data(df)
        
        # Create label mapping
        label_map = {label: idx for idx, label in enumerate(df['label_text'].unique())}
        
        # Split dataset
        X_train, X_test, y_train, y_test = train_test_split(
            df['text'], 
            df['label_text'],
            test_size=TEST_SIZE, 
            stratify=df['label_text'],
            random_state=42
        )
        
        print(f"Training samples: {len(X_train)}")
        print(f"Testing samples: {len(X_test)}")
        print(f"Number of classes: {len(label_map)}")
        
        return X_train, X_test, y_train, y_test, label_map
        
    except FileNotFoundError:
        raise FileNotFoundError(f"Data file not found at: {data_path}")
    except Exception as e:
        raise Exception(f"Error preparing datasets: {str(e)}")




# def prepare_datasets(data_path):
#     """Load and split dataset into train and test sets."""
#     try:
#         # Load data
#         df = pd.read_csv(data_path)
        
#         # Preprocess 'text' and 'symptoms' separately
#         df['text'] = df['text'].apply(preprocess_text)
#         df['symptoms'] = df['symptoms'].fillna("").apply(preprocess_text)  # Fill NaN and preprocess
        
#         # Validate and filter data
#         df = validate_data(df)
        
#         # Create label mapping
#         label_map = {label: idx for idx, label in enumerate(df['label_text'].unique())}
        
#         # Split dataset
#         X_train, X_test, y_train, y_test = train_test_split(
#             df[['text', 'symptoms']],  # Return both columns as features
#             df['label_text'],
#             test_size=TEST_SIZE, 
#             stratify=df['label_text'],
#             random_state=42
#         )
        
#         print(f"Training samples: {len(X_train)}")
#         print(f"Testing samples: {len(X_test)}")
#         print(f"Number of classes: {len(label_map)}")
        
#         return X_train, X_test, y_train, y_test, label_map
        
#     except FileNotFoundError:
#         raise FileNotFoundError(f"Data file not found at: {data_path}")
#     except Exception as e:
#         raise Exception(f"Error preparing datasets: {str(e)}")
