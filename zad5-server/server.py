from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from passlib.context import CryptContext

fake_users_db = {
    "user": {
        "username": "user",
        "hashed_password": "$2b$12$XxJvSHdzJ/PBcV6ysSCy.u5nniTxnnoeyT3rEdNh7hB6MLoA6JYOW",  # "password"
    }
}

class LoginRequest(BaseModel):
    username: str
    password: str

class RegisterRequest(BaseModel):
    username: str
    password: str

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def hash_password(password: str):
    return pwd_context.hash(password)

def get_user(db, username: str):
    return db.get(username)

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

@app.post("/register")
async def register(request: RegisterRequest):
    if get_user(fake_users_db, request.username):
        raise HTTPException(
            status_code=400,
            detail="Username already registered",
        )
    hashed_password = hash_password(request.password)
    fake_users_db[request.username] = {"username": request.username, "hashed_password": hashed_password}
    return {"message": "User registered successfully"}

@app.get("/check-user/{username}")
async def check_user(username: str):
    user = get_user(fake_users_db, username)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return {"message": "User exists"}
