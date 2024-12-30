"""Medical text classification model implementation."""
from sklearn.pipeline import Pipeline
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score
from sklearn.metrics import classification_report
from sklearn.model_selection import StratifiedKFold
import joblib
# from sklearn.compose import ColumnTransformer
# from sklearn.preprocessing import FunctionTransformer

from config import TFIDF_CONFIG, CLASSIFIER_CONFIG

class MedicalTextClassifier:
    def __init__(self):
        self.pipeline = Pipeline([
            ('tfidf', TfidfVectorizer(**TFIDF_CONFIG)),
            ('classifier', RandomForestClassifier(**CLASSIFIER_CONFIG))
        ])

# class MedicalTextClassifier:
#     def __init__(self):
#         # Define separate pipelines for 'text' and 'symptoms'
#         text_pipeline = Pipeline([
#             ('tfidf', TfidfVectorizer(**TFIDF_CONFIG))
#         ])
#         symptoms_pipeline = Pipeline([
#             ('tfidf', TfidfVectorizer(**TFIDF_CONFIG))
#         ])
        
#         # Combine the pipelines for 'text' and 'symptoms'
#         self.pipeline = Pipeline([
#             ('features', ColumnTransformer([
#                 ('text', text_pipeline, 'text'),
#                 ('symptoms', symptoms_pipeline, 'symptoms')
#             ])),
#             ('classifier', RandomForestClassifier(**CLASSIFIER_CONFIG))
#         ])
    


    # def train(self, X_train, y_train, X_test, y_test):
    #     """Train and evaluate the model."""
    #     print("Training model...")
    #     self.pipeline.fit(X_train, y_train)
        
    #     # Cross-validation
    #     scores = cross_val_score(self.pipeline, X_train, y_train, cv=5)
    #     print(f"Cross-validation scores: {scores}")
    #     print(f"Average CV score: {scores.mean():.2f} (+/- {scores.std() * 2:.2f})")
        
    #     # Evaluation
    #     print("\nModel Performance:")
    #     y_pred = self.pipeline.predict(X_test)
    #     print(classification_report(y_test, y_pred))
        
    #     return y_pred

    def train(self, X_train, y_train, X_test, y_test):
        """Train and evaluate the model."""
        print("Training model...")
        self.pipeline.fit(X_train, y_train)
    
        # Cross-validation with fewer splits
        cv = StratifiedKFold(n_splits=3, shuffle=True, random_state=42)
        scores = cross_val_score(self.pipeline, X_train, y_train, cv=cv)
        print(f"Cross-validation scores: {scores}")
        print(f"Average CV score: {scores.mean():.2f} (+/- {scores.std() * 2:.2f})")
    
        # Evaluation
        print("\nModel Performance:")
        y_pred = self.pipeline.predict(X_test)
        print(classification_report(y_test, y_pred))
    
        return y_pred

    def predict(self, text):
        """Predict the label for a given text."""
        return self.pipeline.predict([text])[0]
    
    def save_model(self, path='medical_classifier1.joblib'):
        """Save the trained model."""
        joblib.dump(self.pipeline, path)
    
    @classmethod
    def load_model(cls, path='medical_classifier.joblib'):
        """Load a trained model."""
        instance = cls()
        instance.pipeline = joblib.load(path)
        return instance
    