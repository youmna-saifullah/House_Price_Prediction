from flask import Flask, request, jsonify
import joblib
import pandas as pd
import numpy as np

app = Flask(__name__)

# Load model
model = joblib.load('house_price_model.joblib')

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Get data from request
        data = request.json
        
        # Create DataFrame with correct feature names
        input_data = pd.DataFrame([{
            'longitude': data['longitude'],
            'latitude': data['latitude'],
            'housing_median_age': data['housing_median_age'],
            'population': data['population'],
            'households': data['households'],
            'median_income': data['median_income'],
            'ocean_proximity': data['ocean_proximity'],
            'rooms_per_house': data['total_rooms'] / data['households'],
            'bedroom_ratio': data['total_bedrooms'] / data['total_rooms']
        }])
        
        # Make prediction
        prediction = model.predict(input_data)
        
        return jsonify({
            'prediction': float(prediction[0]),
            'status': 'success'
        })
    
    except Exception as e:
        return jsonify({
            'error': str(e),
            'status': 'error'
        })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)