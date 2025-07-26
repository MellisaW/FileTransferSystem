from flask import Flask, render_template, request, redirect, session, flash, url_for, send_file
import mysql.connector
from mysql.connector import Error
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime, timedelta
import socket
import io
import os
from werkzeug.utils import secure_filename
from cryptography.fernet import Fernet, InvalidToken


UPLOAD_FOLDER = 'uploads'
ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg', 'jpeg', 'docx'}

# Security settings
MAX_FAILED = 5
LOCKOUT_DURATION = timedelta(minutes=10)

KEY_FILE_PATH = 'fernet_key.key'

app = Flask(__name__)
app.secret_key = 'supersecret'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


# Generate a key 
def load_or_generate_fernet_key():
    if os.path.exists(KEY_FILE_PATH):
        with open(KEY_FILE_PATH, 'rb') as key_file:
            key = key_file.read()
            print(f"DEBUG: Loaded Fernet key from {KEY_FILE_PATH}")
    else:
        key = Fernet.generate_key()
        with open(KEY_FILE_PATH, 'wb') as key_file:
            key_file.write(key)
        print(f"DEBUG: Generated new Fernet key and saved to {KEY_FILE_PATH}")
    return key

FERNET_KEY = load_or_generate_fernet_key()
fernet = Fernet(FERNET_KEY)

def encrypt_file(data: bytes) -> bytes:
    return fernet.encrypt(data)

def decrypt_file(encrypted_data: bytes) -> bytes:
    try:
        return fernet.decrypt(encrypted_data)
    except InvalidToken:
        print("ERROR: Decryption failed: InvalidToken. This could mean the key is wrong or data is corrupted.")
        raise
    except Exception as e:
        print(f"ERROR: An unexpected error occurred during decryption: {e}")
        raise


# DB config (same as PHP/phpMyAdmin)
db_config = {
    'host': 'localhost',
    'user': 'mellisa',
    'password': 'Wagy1962',
    'database': 'FILE SYSTEM'
}

def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="mellisa",
        password="Wagy1962",
        database="FILE SYSTEM",
        auth_plugin='mysql_native_password'
    )
    conn = get_db_connection()
    cur = conn.cursor(buffered=True, dictionary=True)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def log_event(action, filename, username, status):

    print(f"\nDEBUG: --- Attempting to log event ---")
    print(f"DEBUG: Action: {action}, Filename: {filename}, User: {username}, Status: {status}")

    conn = mysql.connector.connect(
        host="localhost",
        user="mellisa",
        password="Wagy1962",
        database="FILE SYSTEM"
    )
    cur = conn.cursor()

    ip_address = request.remote_addr
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    cur.execute(
        "INSERT INTO logs (filename, action, username, ip_address, timestamp, status) VALUES (%s, %s, %s, %s, %s, %s)",
        (filename, action, username, ip_address, timestamp, status)
    )

    print(f"DEBUG: log_event: INSERT query executed. Rows affected: {cur.rowcount}")

    conn.commit()
    cur.close()
    conn.close()

@app.route('/')
def home():
    return render_template('login.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    user = None
    if request.method == 'POST':
       username = request.form['username']
       password = request.form['password']

       conn = mysql.connector.connect(
           host='localhost',
           user='mellisa',
           password='Wagy1962',
           database='FILE SYSTEM'
        )
       conn = get_db_connection()
       cur = conn.cursor(dictionary=True, buffered=True)
       cur.execute("SELECT * FROM users WHERE username = %s", (username,))
       user = cur.fetchone()

       if user:
           now = datetime.utcnow()
           if (user['failed_attempts'] >= MAX_FAILED and
               now - user['last_failed'] < LOCKOUT_DURATION):
               flash("Account locked. Try again later.", "danger")
               return render_template('login.html')

           if check_password_hash(user['passhash'], password):
               cur.execute("UPDATE users SET failed_attempts=0, last_failed=NULL WHERE username=%s", (username,))
               conn.commit()
               session['username'] = user['username']
               return redirect(url_for('upload_file'))
           else:
               cur.execute("""
                   UPDATE users
                   SET failed_attempts = failed_attempts + 1, last_failed = %s
                   WHERE username = %s""", (now, username))
               conn.commit()
               flash("Invalid credentials.", "danger")
       else:
           flash('Invalid username or password.')
       cur.close()
       conn.close()

    return render_template('login.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
       username = request.form['username']
       email = request.form['email']
       password = request.form['password']

       hashed_password = generate_password_hash(password)

       conn = mysql.connector.connect(
           host='localhost',
           user='mellisa',
           password='Wagy1962',
           database='FILE SYSTEM'
        )
       cur = conn.cursor()
       cur.execute("SELECT * FROM users WHERE username = %s", (username,))
       user = cur.fetchone()

       if user:
           flash('Username already exists. Try a different one.')
           return redirect(url_for('register'))

       cur.execute("INSERT INTO users (username, email, passhash) VALUES (%s, %s, %s)",
                  (username, email, hashed_password))
       conn.commit()
       cur.close()
       conn.close()

       flash('Successfully registered. Please log in.')
       return redirect(url_for('login'))  # redirect back to login
    return render_template('register.html')

@app.route('/success')
def success():
    if 'username' not in session:
        return redirect('/')
    return render_template('success.html', username=session['username'])

@app.route('/upload', methods=['GET', 'POST'])
def upload_file():
    if 'username' not in session:
        return redirect(url_for('login'))

    username = session['username']
    files = []

    if request.method == 'POST':
        uploaded_file = request.files.get('file')
        if not uploaded_file or uploaded_file.filename == '':
            flash('No file selected', 'warning')
            return redirect(request.url)

    #Check if file type is allowed
        if not allowed_file(uploaded_file.filename):
            flash('Invalid file type.', 'warning')
            return redirect(request.url)

        file_data = uploaded_file.read()
        #encrypt file
        encrypted_data = encrypt_file(file_data)

        filename = secure_filename(uploaded_file.filename)
        encrypted_filename = filename + '.enc'

        #save file
        save_path = os.path.join(app.config['UPLOAD_FOLDER'], encrypted_filename)

        try:
            with open(save_path, 'wb') as f:
                f.write(encrypted_data)
        except Exception as e:
            flash(f"Error saving encrypted file to disk: {e}", "danger")
            return redirect(request.url)


        #Save metadata to database
        conn = mysql.connector.connect(
            host="localhost",
            user="mellisa",
            password="Wagy1962",
            database="FILE SYSTEM"
        )
        cur = conn.cursor()
        cur.execute("INSERT INTO files (filename, owner, path) VALUES (%s, %s, %s)", (encrypted_filename, username, save_path))
        conn.commit()
        cur.close()
        conn.close()

        log_event('upload', encrypted_filename, username, 'success')

        flash('File uploaded successfully.', 'success')
        return redirect(url_for('upload_file'))

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    cur.execute("SELECT filename FROM files WHERE owner = %s", (username,))
    files = [row['filename'] for row in cur.fetchall()]
    cur.close()
    conn.close()

    return render_template('upload.html', files=files)


@app.route('/delete/<filename>', methods=['POST'])
def delete_file(filename):
    if 'username' not in session:
        flash("Unauthorized access.", "danger")
        return redirect(url_for('login'))

    username = session['username']
    user_folder = os.path.join(app.config['UPLOAD_FOLDER'], username)
    file_path = os.path.join(user_folder, filename)

    conn = None
    cur = None 
    try:
        conn = get_db_connection()
        cur = conn.cursor()

        # STEP 1: Verify ownership and get file path from DB
        cur.execute("SELECT path FROM files WHERE filename = %s AND owner = %s", (filename, username))
        file_entry_path = cur.fetchone()

        if file_entry_path:
            # STEP 2: Delete from database
            cur.execute("DELETE FROM files WHERE filename = %s AND owner = %s", (filename, username))
            db_rows_affected = cur.rowcount

            conn.commit()

            # STEP 3: Delete the actual file from the file system
            if os.path.exists(file_path):
                os.remove(file_path)
                flash(f"File '{filename.replace('.enc', '')}' deleted successfully.", "success")
            else:
                flash(f"File '{filename.replace('.enc', '')}' deleted from database.", "warning")

            log_event('delete', filename, username, 'success')
        else:
            flash("File not found or you don't have permission to delete it.", "danger")
            print(f"WARNING: Deletion denied. File '{filename}' not found or owner mismatch for user '{username}'.")
            log_event('delete', filename, username, 'permission_denied') # Log denied attempt

    except Error as e:
        print(f"ERROR: Database error during deletion: {e}")
        flash("Error deleting file.", "danger")
        if conn:
            conn.rollback()
        log_event('delete', filename, username, 'db_error')
    except Exception as e:
        print(f"CRITICAL ERROR: An unexpected error occurred during deletion: {e}")
        flash("An unexpected error occurred during deletion.", "danger")
        log_event('delete', filename, username, 'server_error')
    finally:
        if cur: cur.close()
        if conn: conn.close()
        print("DEBUG: Database connection and cursor closed.")

    return redirect(url_for('upload_file'))

    if os.path.exists(file_path):
       os.remove(file_path)
       log_event('delete', filename, username, 'success')
       flash(f"{filename} deleted successfully!", "info")
    else:
        flash(f"{filename} not found or already deleted.", "warning")

    return redirect(url_for('upload_file'))


@app.route('/logout')
def logout():
    session.clear()
    flash('You have been logged out.')
    return redirect(url_for('login'))



@app.route('/dashboard')
def dashboard():

    conn = mysql.connector.connect(
        host="localhost",
        user="mellisa",
        password="Wagy1962",
        database="FILE SYSTEM"
    )
    cur = conn.cursor(dictionary=True, buffered = True)
    cur.execute("SELECT * FROM logs ORDER BY timestamp DESC")
    logs = cur.fetchall()
    cur.close()
    conn.close()

    print("DBG: logs count =", len(logs))

    return render_template('dashboard.html', logs=logs)


@app.route('/download/<filename>')
def download_file(filename):
    if 'username' not in session:
        return redirect(url_for('login'))

    username = session['username']
    save_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)

    conn = mysql.connector.connect(
        host="localhost",
        user="mellisa",
        password="Wagy1962",
        database="FILE SYSTEM"
    )
    # Check if file exists
    cur = conn.cursor(buffered=True, dictionary=True)

    file_entry = None
    try:
        # Check if file exists and belongs to the user
        cur.execute("SELECT * FROM files WHERE filename = %s AND owner = %s", (filename, username))
        file_entry = cur.fetchone()
    except Error as e:
        print(f"ERROR: Database error checking file existence for download: {e}")
        flash("Error checking file permissions.", "danger")
        return redirect(url_for('upload_file'))
    finally:
        if cur: cur.close()
        if conn: conn.close()

    if not file_entry:
        flash("File not found or you don't have permission.", "danger")
        log_event('download', filename, username, 'permission_denied')
        return redirect(url_for('upload_file'))

    if not os.path.exists(save_path):
        flash("Encrypted file not found on server storage.", "danger")
        log_event('download', filename, username, 'file_not_found_disk')
        return redirect(url_for('upload_file'))

    # Read encrypted file
    encrypted_data = None
    try:
        with open(save_path, 'rb') as f:
            encrypted_data = f.read()
    except Exception as e:
        flash(f"Error reading encrypted file from disk: {e}", "danger")
        log_event('download', filename, username, 'read_error')
        return redirect(url_for('upload_file'))

    # Decrypt
    decrypted_data = None
    try:
        decrypted_data = decrypt_file(encrypted_data)
    except InvalidToken:
        flash("Decryption failed. The file might be corrupted or encrypted with a different key.", "danger")
        log_event('download', filename, username, 'decryption_failed')
        return redirect(url_for('upload_file'))
    except Exception as e:
        flash(f"An unexpected error occurred during decryption: {e}", "danger")
        log_event('download', filename, username, 'decryption_error')
        return redirect(url_for('upload_file'))

    # Send file as attachment
    file_stream = io.BytesIO(decrypted_data)
    download_name = filename.replace('.enc', '') if filename.endswith('.enc') else filename

    # Log the successful download
    log_event('download', download_name, username, 'success')

    return send_file(file_stream, as_attachment=True, download_name=download_name)




if __name__ == '__main__':
    app.run(debug=True, ssl_context=('cert.pem', 'key.pem'))

