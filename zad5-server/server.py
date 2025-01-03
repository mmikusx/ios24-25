from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from passlib.context import CryptContext

# Mock database
fake_users_db = {
    "user": {
        "username": "user",
        "hashed_password": "$2b$12$XxJvSHdzJ/PBcV6ysSCy.u5nniTxnnoeyT3rEdNh7hB6MLoA6JYOW",  # "password"
    }
}

# Models
class LoginRequest(BaseModel):
    username: str
    password: str

# Password hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Verify password
def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

# Get user from database
def get_user(db, username: str):
    return db.get(username)

# FastAPI app
app = FastAPI()

@app.post("/login")
async def login(request: LoginRequest):
    user = get_user(fake_users_db, request.username)
    if not user or not verify_password(request.password, user["hashed_password"]):
        raise HTTPException(
            status_code=401,
            detail="Incorrect username or password",
        )
    return {"message": "Login successful"}

# Endpoint to test user existence
@app.get("/check-user/{username}")
async def check_user(username: str):
    user = get_user(fake_users_db, username)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return {"message": "User exists"}

# Run this app with 'uvicorn main:app --reload'
