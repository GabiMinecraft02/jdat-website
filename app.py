from flask import Flask, send_from_directory, request, abort
from supabase import create_client
import os

app = Flask(__name__)

# === PATHS ===
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
FILES_DIR = os.path.join(BASE_DIR, "files")

# === SECURITY ===
INSTALL_TOKEN = os.environ.get("JDAT_INSTALL_TOKEN")

def check_token():
    token = request.args.get("token")
    if token != INSTALL_TOKEN:
        abort(403)

# === SUPABASE ===
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_SERVICE_KEY = os.environ.get("SUPABASE_SERVICE_KEY")

supabase = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)

def increment_downloads():
    supabase.rpc("increment_downloads").execute()

# === ROUTES ===

@app.route("/")
def index():
    return "JDAT server running"

@app.route("/download/<filename>")
def download_file(filename):
    check_token()

    allowed_files = {
        "jdat.exe",
        "jdat-shell.exe",
        "version.txt"
    }

    if filename not in allowed_files:
        abort(404)

    # Count only exe downloads
    if filename.endswith(".exe"):
        increment_downloads()

    return send_from_directory(
        FILES_DIR,
        filename,
        as_attachment=True
    )

# === MAIN ===
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
