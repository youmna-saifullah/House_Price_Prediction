import pandas as pd
import numpy as np
import joblib
from sklearn.ensemble import HistGradientBoostingRegressor
from sklearn.preprocessing import OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline

def train_and_save_model():
    # Load data
    data = pd.read_csv("housing.csv")
    data.dropna(inplace=True)
    
    # Feature engineering
    data['rooms_per_house'] = data['total_rooms'] / data['households']
    data['bedroom_ratio'] = data['total_bedrooms'] / data['total_rooms']
    data = data.drop(['total_rooms', 'total_bedrooms'], axis=1)
    
    # Prepare features and target
    X = data.drop('median_house_value', axis=1)
    y = data['median_house_value']
    
    # Create pipeline
    numeric_features = ['housing_median_age', 'population', 'households', 
                      'median_income', 'rooms_per_house', 'bedroom_ratio']
    categorical_features = ['ocean_proximity']
    
    preprocessor = ColumnTransformer(
        transformers=[
            ('num', 'passthrough', numeric_features),
            ('cat', OneHotEncoder(handle_unknown='ignore'), categorical_features)
        ])
    
    model = Pipeline([
        ('preprocessor', preprocessor),
        ('regressor', HistGradientBoostingRegressor(
            random_state=42,
            max_iter=200,
            learning_rate=0.1,
            max_depth=5,
            min_samples_leaf=10
        ))
    ])
    
    # Train and save model
    model.fit(X, y)
    joblib.dump(model, 'house_price_model.joblib')
    print("Model trained and saved successfully!")

if __name__ == "__main__":
    train_and_save_model()