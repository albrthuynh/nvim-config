from flask import Flask, jsonify, request
from flask_jwt_extended import JWTManager, create_access_token, jwt_required

app = Flask(__name__)

app.config["JWT_SECRET_KEY"] = (
    "your-secret-key"  # Secret key used to sign and verify JWT tokens
)
jwt = JWTManager(
    app
)  # Initializes the JWTManager instance for managing JWT-related functionalities within the Flask app

users = {}  # Simple in-memory store for users


# something something
@app.route("/register", methods=["POST"])
def register():
    data = request.get_json()
    username = data.get("username")
    password = data.get("password")

    if not username or not password:
        return jsonify({"error": "Username and password are required."}), 400

    if username in users:
        return jsonify({"error": "User already exists."}), 400

    users[username] = password
    return jsonify({"message": "User registered successfully."}), 201


@app.route("/auth", methods=["POST"])
def auth():
    return {"message": " placeholder for now"}


@app.route("/")
def home():
    return {"message": "Welcome to the Flask API!"}


if __name__ == "__main__":
    app.run(debug=True)
