"""Main script to run the medical text classifier."""
import os
from data_handler import prepare_datasets
from model import MedicalTextClassifier

def main():
    # Get the current directory and construct the data path
    current_dir = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(current_dir, 'data', 'cleaned_rows.csv')
    
    # Prepare data
    X_train, X_test, y_train, y_test, label_map = prepare_datasets(data_path)
    print("Rare classes handled and dataset augmented where necessary.")
    print("Data validation and augmentation completed.")


    
    # Initialize and train
    classifier = MedicalTextClassifier()
    classifier.train(X_train, y_train, X_test, y_test)
    
    # Save model
    classifier.save_model()
    
    # Example prediction
    sample_text = "My nose is always stuffy and congested, and my eyes are always red and itchy. I feel unwell and fatigued, and I keep coughing up this gunk. I have a scratchy, irritated throat, and my neck's lymph nodes are swollen."
    prediction = classifier.predict(sample_text)
    print(f"\nSample Prediction:")
    print(f"Text: {sample_text}")
    print(f"Predicted Label: {prediction}")

if __name__ == '__main__':
    main()