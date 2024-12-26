import sys
sys.path.append('..')

import torch
from torch.utils.data import Dataset, DataLoader
import torch.nn as nn
import torch.optim as optim
from torch.nn import CrossEntropyLoss
from tqdm import tqdm
from transformers import (
    BertTokenizer,
    BertModel
    
)
from sklearn.model_selection import train_test_split
import pandas as pd
from typing import Dict
import logging
from transformers import AutoTokenizer, AutoModel
# Uncomment the lines below if the respective modules are implemented and needed
# from src.dataset import prepare_datasets
# from src.model import MedicalBERT
#from src.trainer import ModelTrainer

# Your remaining code goes here


class MedicalDataset(Dataset):
    def __init__(self, texts, labels, tokenizer, max_length=128):
        self.texts = texts
        self.labels = labels
        self.tokenizer = tokenizer
        self.max_length = max_length

    def __len__(self):
        return len(self.texts)

    
    def __getitem__(self, idx):
        text = str(self.texts[idx])
        label = self.labels[idx]

        encoding = self.tokenizer(
            text,
            add_special_tokens=True,
            max_length=self.max_length,
            padding='max_length',
            truncation=True,
            return_tensors='pt'
    )

    
        return {
        'input_ids': encoding['input_ids'].flatten(),
        'attention_mask': encoding['attention_mask'].flatten(),
        'label': torch.tensor(label, dtype=torch.long)  # Cast to LongTensor
        }

def prepare_datasets(data_path, tokenizer, test_size=0.2, val_size=0.5):
    """Load and split dataset into train, validation, and test sets"""
    df = pd.read_csv(data_path)
    
    # Create label mapping
    label_map = {label: idx for idx, label in enumerate(df['label_text'].unique())}
    
    # Split dataset
    train_df, temp_df = train_test_split(df, test_size=test_size, random_state=42)
    val_df, test_df = train_test_split(temp_df, test_size=val_size, random_state=42)
    
    # Create datasets
    train_dataset = MedicalDataset(train_df['text'].values, train_df['label'].values, tokenizer)
    val_dataset = MedicalDataset(val_df['text'].values, val_df['label'].values, tokenizer)
    test_dataset = MedicalDataset(test_df['text'].values, test_df['label'].values, tokenizer)
    
    return train_dataset, val_dataset, test_dataset, label_map



class MedicalBERT(nn.Module):
    def __init__(self, num_labels):
        super().__init__()
        self.bert = AutoModel.from_pretrained('dmis-lab/biobert-v1.1')
        self.dropout = nn.Dropout(0.1)
        self.classifier = nn.Linear(self.bert.config.hidden_size, num_labels)

    def forward(self, input_ids, attention_mask, labels=None):
        outputs = self.bert(input_ids=input_ids, attention_mask=attention_mask)
        pooled_output = outputs.pooler_output  # Check if `pooler_output` is available
        pooled_output = self.dropout(pooled_output)
        logits = self.classifier(pooled_output)
        
        loss = None
        if labels is not None:
            loss_fn = nn.CrossEntropyLoss()
            loss = loss_fn(logits, labels)

        return logits, loss  # Explicitly return both logits and loss
        
        # return SequenceClassifierOutput(
        #     loss=loss,
        #     logits=logits
        # )


class ModelTrainer:
    def __init__(self, model, device):
        self.model = model
        self.device = device

    def train(self, train_dataset, val_dataset, batch_size=16, epochs=3, learning_rate=5e-5):
        train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
        val_loader = DataLoader(val_dataset, batch_size=batch_size)
        optimizer = optim.AdamW(self.model.parameters(), lr=learning_rate)

        for epoch in range(epochs):
            # Training Phase
            self.model.train()
            train_loss = 0

            for batch in tqdm(train_loader, desc=f"Training Epoch {epoch+1}"):
                input_ids = batch['input_ids'].to(self.device)
                attention_mask = batch['attention_mask'].to(self.device)
                labels = batch['label'].to(self.device)

                optimizer.zero_grad()
                outputs = self.model(input_ids=input_ids, attention_mask=attention_mask, labels=labels)
                loss = outputs.loss
                loss.backward()
                optimizer.step()

                train_loss += loss.item()

            print(f"Epoch {epoch+1}, Training Loss: {train_loss / len(train_loader)}")

            # Validation Phase
            self.model.eval()
            val_loss = 0
            with torch.no_grad():
                for batch in tqdm(val_loader, desc=f"Validation Epoch {epoch+1}"):
                    input_ids = batch['input_ids'].to(self.device)
                    attention_mask = batch['attention_mask'].to(self.device)
                    labels = batch['label'].to(self.device)

                    outputs = self.model(input_ids=input_ids, attention_mask=attention_mask, labels=labels)
                    val_loss += outputs.loss.item()

            print(f"Epoch {epoch+1}, Validation Loss: {val_loss / len(val_loader)}")

# Modify the `train` method in your `ModelTrainer` class to use standard `tqdm`.
class ModelTrainer:
    def __init__(self, model, device):
        self.model = model
        self.device = device

    def train(self, train_dataset, val_dataset, batch_size=16, epochs=3, learning_rate=5e-5):
        from torch.utils.data import DataLoader
        import torch.optim as optim
        from torch.nn import CrossEntropyLoss
        
        train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
        val_loader = DataLoader(val_dataset, batch_size=batch_size)
        optimizer = optim.Adam(self.model.parameters(), lr=learning_rate)
        loss_fn = CrossEntropyLoss()

        for epoch in range(epochs):
            self.model.train()
            train_loss = 0


            for batch in train_loader:
                self.model.train()
                input_ids, attention_mask, labels = batch['input_ids'].to(self.device), batch['attention_mask'].to(self.device), batch['label'].to(self.device)
    
                outputs = self.model(input_ids=input_ids, attention_mask=attention_mask, labels=labels)
                logits = outputs[0]  # Assuming `outputs` is a tuple where the first element is logits
    
                loss_fn = nn.CrossEntropyLoss()
                loss = loss_fn(logits, labels)  # Compute the loss manually
    
                optimizer.zero_grad()
                loss.backward()
                optimizer.step()
    
            train_loss += loss.item()

            




            print(f"Epoch {epoch+1}, Training Loss: {train_loss/len(train_loader)}")

            



            # Validation phase
            self.model.eval()
            val_loss = 0.0
            correct = 0
            total = 0

            with torch.no_grad():
                for batch in val_loader:
                    input_ids, attention_mask, labels = (
                        batch['input_ids'].to(self.device),
                        batch['attention_mask'].to(self.device),
                        batch['label'].to(self.device),
                    )

                    outputs = self.model(input_ids=input_ids, attention_mask=attention_mask, labels=labels)
                    logits = outputs[0]  # Extract logits from the tuple

                    loss_fn = nn.CrossEntropyLoss()
                    loss = loss_fn(logits, labels)  # Compute the loss manually
                    val_loss += loss.item()

                    # Accuracy calculation (optional, based on task)
                    _, predicted = torch.max(logits, 1)
                    total += labels.size(0)
                    correct += (predicted == labels).sum().item()


            val_loss /= len(val_loader)
            val_accuracy = 100 * correct / total
            print(f"Epoch {epoch+1}, Validation Loss: {val_loss}, Validation Accuracy: {val_accuracy:.2f}%")      



# Reverse mapping from numeric labels to label_text
def predict_text(model, tokenizer, text, device, reverse_label_map):
    model.eval()
    with torch.no_grad():
        encoding = tokenizer(
            text,
            add_special_tokens=True,
            max_length=128,
            padding='max_length',
            truncation=True,
            return_tensors='pt'
        )
        input_ids = encoding['input_ids'].to(device)
        attention_mask = encoding['attention_mask'].to(device)

        outputs = model(input_ids=input_ids, attention_mask=attention_mask)
        logits = outputs[0]  # Extract logits
        _, predicted_label = torch.max(logits, dim=1)

        # Map numeric label to label_text
        label_text = reverse_label_map[predicted_label.item()]
        return label_text


def main():
    # Device setup
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    print(f'Using device: {device}')

    # Initialize tokenizer and prepare datasets
    tokenizer = BertTokenizer.from_pretrained('dmis-lab/biobert-v1.1')
    train_dataset, val_dataset, test_dataset, label_map = prepare_datasets(
        'src/data/cleaned_rows.csv',
        tokenizer
    )

    # Initialize model
    model = MedicalBERT(num_labels=len(label_map))
    model.to(device)

    # Reverse label map for inference
    reverse_label_map = {v: k for k, v in label_map.items()}

    # Train the model
    trainer = ModelTrainer(model, device)
    trainer.train(train_dataset, val_dataset, epochs=10)

    # Example of predicting on a sample text after training
    sample_text = "I have asthma and I get wheezing and breathing problems."
    predicted_label_text = predict_text(model, tokenizer, sample_text, device, reverse_label_map)
    print(f"Predicted Label Text: {predicted_label_text}")

if __name__ == '__main__':
    main()