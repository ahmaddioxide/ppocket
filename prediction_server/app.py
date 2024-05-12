from flask import Flask, jsonify, request
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import PolynomialFeatures, StandardScaler
from sklearn.linear_model import Ridge
from sklearn.metrics import r2_score

app = Flask(__name__)

@app.route('/get_prediction', methods=['GET'])
def recommend():
    tool_history = []
    for count in range(500):
        x1 = np.random.randint(2500, 3000)  # expense range of 1st transaction
        tool_history.append([x1, 0])  # Transport
        x2 = np.random.randint(1000, 1500)  # expense range of 2nd transaction
        tool_history.append([x2, 1])  # Food
        x3 = np.random.randint(1500, 2000)  # expense range of 3rd transaction
        tool_history.append([x3, 2])  # Education
        x4 = np.random.randint(1500, 2000)  # expense range of 4th transaction
        tool_history.append([x4, 3])  # Transfer

    tool_history = np.array(tool_history)

    # Splitting data into features (X) and target (y)
    X = tool_history[:, 1].reshape(-1, 1)
    y = tool_history[:, 0]

    # Splitting data into training and testing sets
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Polynomial features transformation
    poly = PolynomialFeatures(degree=3)
    X_train_poly = poly.fit_transform(X_train)
    X_test_poly = poly.transform(X_test)

    # Feature scaling
    scaler = StandardScaler()
    X_train_poly_scaled = scaler.fit_transform(X_train_poly)
    X_test_poly_scaled = scaler.transform(X_test_poly)

    # Creating and training the polynomial regression model with regularization
    ridge = Ridge(alpha=0.1)  # You can adjust alpha for better performance
    ridge.fit(X_train_poly_scaled, y_train)

    # Predicting expenses for testing set
    y_pred = ridge.predict(X_test_poly_scaled)

    # Calculating accuracy (R-squared score)
    accuracy = r2_score(y_test, y_pred)

    # Predicting expenses for each category
    x1_prediction = ridge.predict(scaler.transform(poly.transform([[0]])))[0]  # Transport
    x2_prediction = ridge.predict(scaler.transform(poly.transform([[1]])))[0]  # Food
    x3_prediction = ridge.predict(scaler.transform(poly.transform([[2]])))[0]  # Education
    x4_prediction = ridge.predict(scaler.transform(poly.transform([[3]])))[0]  # Transfer

    result = {
        "Predicted expenses": {
            "Transport": x1_prediction,
            "Food": x2_prediction,
            "Education": x3_prediction,
            "Transfer": x4_prediction
        },
        "Accuracy": accuracy
    }

    print("Predicted expenses:")
    print("x1 (Transport):", x1_prediction)
    print("x2 (Food):", x2_prediction)
    print("x3 (Education):", x3_prediction)

    return jsonify(result)

if __name__ == "__main__":
    app.run(host='127.0.0.3', port=5000, debug=True)
