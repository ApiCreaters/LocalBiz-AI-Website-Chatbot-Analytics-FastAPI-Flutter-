# ──────────────────────────────────────────────────────────────
#  LocalBiz FastAPI Backend
#  Run:  uvicorn main:app --reload --host 127.0.0.1 --port 8080
# ──────────────────────────────────────────────────────────────

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from datetime import datetime
import pandas as pd
import os
import json

# ── App Setup ─────────────────────────────────────────────────
app = FastAPI(title="LocalBiz API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],          # In production: restrict to your domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── File Paths ─────────────────────────────────────────────────
LEADS_FILE = "leads.csv"
CHATS_FILE = "chats.csv"

# ── CSV Helpers ────────────────────────────────────────────────
def init_csv(filepath: str, columns: list):
    """Create CSV file with headers if it doesn't exist."""
    if not os.path.exists(filepath):
        df = pd.DataFrame(columns=columns)
        df.to_csv(filepath, index=False)

def append_row(filepath: str, row: dict):
    """Append a single row dict to a CSV file."""
    df_new = pd.DataFrame([row])
    header = not os.path.exists(filepath) or os.path.getsize(filepath) == 0
    df_new.to_csv(filepath, mode="a", header=header, index=False)

def read_csv_safe(filepath: str) -> pd.DataFrame:
    """Read CSV, return empty DataFrame if file missing or empty."""
    if not os.path.exists(filepath) or os.path.getsize(filepath) == 0:
        return pd.DataFrame()
    try:
        return pd.read_csv(filepath)
    except Exception:
        return pd.DataFrame()

# ── Initialise files on startup ────────────────────────────────
init_csv(LEADS_FILE, ["timestamp", "name", "email", "message"])
init_csv(CHATS_FILE, ["timestamp", "user_message", "bot_response"])


# ── Pydantic Models ────────────────────────────────────────────
class ChatRequest(BaseModel):
    message: str

class LeadRequest(BaseModel):
    name: str
    email: str
    message: str


# ── Rule-Based Chatbot Logic ───────────────────────────────────
RESPONSES: dict[str, str] = {
    "hello":       "👋 Hello! Welcome to LocalBiz. How can I help you today?",
    "hi":          "👋 Hi there! What can I assist you with?",
    "hey":         "👋 Hey! How can I help you?",
    "services":    "🛠️ We offer chatbot support, lead management, and business analytics. Type 'pricing' to learn more!",
    "pricing":     "💰 Our plans start from £49/month. Contact us at hello@localbiz.com for a custom quote.",
    "hours":       "🕘 We're open Monday to Friday, 9am – 6pm. You can always reach us on WhatsApp!",
    "location":    "📍 We're based at 123 Main Street, Your City. We also serve clients remotely.",
    "contact":     "📧 Email: hello@localbiz.com | 💬 WhatsApp: +1 234 567 890",
    "whatsapp":    "💬 Chat with us on WhatsApp: https://wa.me/1234567890",
    "demo":        "🚀 You're already in the demo! Fill in the contact form and we'll set up a full walkthrough for you.",
    "help":        "🤝 I can help with: services, pricing, hours, location, contact info, or getting a demo. Just ask!",
    "thank":       "😊 You're welcome! Is there anything else I can help you with?",
    "thanks":      "😊 Happy to help! Let us know if you need anything else.",
    "bye":         "👋 Goodbye! Have a great day. Feel free to come back anytime.",
    "about":       "ℹ️ LocalBiz helps small businesses manage customers, capture leads, and grow — all without complex software.",
    "app":         "📱 Yes! We have a Flutter mobile app. Ask our team for access details.",
    "analytics":   "📊 Our analytics dashboard shows total leads, chat volume, and your most common customer queries.",
}

FALLBACK = "🤔 I'm not sure about that. Try asking about our services, pricing, hours, or type 'help' for options!"

def get_bot_response(message: str) -> str:
    msg_lower = message.lower().strip()
    for keyword, reply in RESPONSES.items():
        if keyword in msg_lower:
            return reply
    return FALLBACK


# ── Endpoints ──────────────────────────────────────────────────

@app.get("/")
def root():
    return {"status": "ok", "message": "LocalBiz API is running ✅"}


@app.post("/chat")
def chat(req: ChatRequest):
    """
    POST /chat
    Body: { "message": "your message" }
    Returns: { "response": "bot reply", "timestamp": "..." }
    """
    if not req.message.strip():
        raise HTTPException(status_code=400, detail="Message cannot be empty.")

    response = get_bot_response(req.message)
    timestamp = datetime.now().isoformat()

    # Save to chat log
    append_row(CHATS_FILE, {
        "timestamp":    timestamp,
        "user_message": req.message.strip(),
        "bot_response": response,
    })

    return {"response": response, "timestamp": timestamp}


@app.post("/lead")
def save_lead(req: LeadRequest):
    """
    POST /lead
    Body: { "name": "...", "email": "...", "message": "..." }
    Returns: { "status": "saved", "timestamp": "..." }
    """
    if not req.name.strip() or not req.email.strip() or not req.message.strip():
        raise HTTPException(status_code=400, detail="All fields are required.")

    timestamp = datetime.now().isoformat()

    append_row(LEADS_FILE, {
        "timestamp": timestamp,
        "name":      req.name.strip(),
        "email":     req.email.strip(),
        "message":   req.message.strip(),
    })

    return {"status": "saved", "timestamp": timestamp}


@app.get("/analytics")
def analytics():
    """
    GET /analytics
    Returns: total_leads, total_messages, most_common_message
    """
    leads_df = read_csv_safe(LEADS_FILE)
    chats_df = read_csv_safe(CHATS_FILE)

    total_leads    = len(leads_df)
    total_messages = len(chats_df)

    most_common_message = "N/A"
    if total_messages > 0 and "user_message" in chats_df.columns:
        most_common_message = (
            chats_df["user_message"]
            .value_counts()
            .idxmax()
        )

    return {
        "total_leads":          total_leads,
        "total_messages":       total_messages,
        "most_common_message":  most_common_message,
    }
