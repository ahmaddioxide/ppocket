from flask import Flask, jsonify, request
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score

app = Flask(__name__)

expenses_data = {}  # Global variable to store expenses data

@app.route('/get_prediction', methods=['GET'])
def recommend():
    try:
        global expenses_data
        
        # Check if expenses data is available
        if not expenses_data:
            return jsonify({'error': 'Expenses data not found. Please send expenses data using POST /post_transactions.'}), 400
        
        predictions = {}
        for name, amounts in expenses_data.items():
            X = np.arange(len(amounts)).reshape(-1, 1)
            y = np.array(amounts)
            
            # Splitting data into training and testing sets
            X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
            
            # Creating and training the linear regression model
            model = LinearRegression()
            model.fit(X_train, y_train)
            
            # Predicting expenses for testing set
            y_pred = model.predict(X_test)
            
            # Calculating accuracy (R-squared score)
            accuracy = r2_score(y_test, y_pred)
            
            # Predicting expenses for the next period
            next_period_prediction = model.predict(np.array([[len(amounts)]]))[0]
            
            predictions[name] = {
                # "Predicted expenses": list(y_pred),
                "Next period prediction": next_period_prediction,
                # "Accuracy": accuracy
            }

        result = {
            "Predictions": predictions,
            # "Expenses Data": expenses_data
        }

        return jsonify(result)
    except Exception as e:
        print(f"Error predicting expenses: {str(e)}")
        return jsonify({'error': 'Failed to predict expenses.'}), 500

@app.route('/post_transactions', methods=['POST'])
def post_transactions():
    try:
        global expenses_data
        data = request.json
        expenses = {}
        for transaction in data:
            name = transaction.get('name')
            amount = transaction.get('amount')
            if name and amount:
                if name in expenses:
                    expenses[name].append(amount)
                else:
                    expenses[name] = [amount]
            else:
                return jsonify({'error': 'Invalid transaction data.'}), 400
        
        expenses_data = expenses  # Store expenses data
        
        # Print expenses grouped by name
        for name, amounts in expenses.items():
            print(f"Expenses for {name}: {amounts}")
        
        return jsonify({'message': 'Expenses received and processed successfully.'}), 200
    except Exception as e:
        print(f"Error processing expenses: {str(e)}")
        return jsonify({'error': 'Failed to process expenses.'}), 500

@app.route('/')
def index():
    return "Server is running!"

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000, debug=True)
