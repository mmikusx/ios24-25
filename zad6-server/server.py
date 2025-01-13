from fastapi import FastAPI, Form
from pydantic import BaseModel

app = FastAPI()

class PaymentForm(BaseModel):
    name: str
    card_number: str
    expiration_date: str
    cvv: str
    amount: float

@app.post("/payment")
def process_payment(
    name: str = Form(...),
    card_number: str = Form(...),
    expiration_date: str = Form(...),
    cvv: str = Form(...),
    amount: float = Form(...),
):
    payment_details = PaymentForm(
        name=name,
        card_number=card_number,
        expiration_date=expiration_date,
        cvv=cvv,
        amount=amount,
    )

    print(payment_details.model_dump())

    return {
        "message": "Payment processed successfully.",
        "payment_details": payment_details.model_dump(),
    }

if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
