import re

def preprocess_text(text):
    """Clean and normalize text data."""
    text = str(text).lower()
    text = re.sub(r'[^a-zA-Z0-9\s]', '', text)  # Allow numbers
    text = ' '.join(text.split())
    return text