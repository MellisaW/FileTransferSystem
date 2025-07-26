# Secure File Transfer System using TLS and AES Encryption
This project is a secure file transfer web application built with Flask (Python). 
It allows authenticated users to upload and download files over a TLS-secured connection with the files themselves being encrypted using AES before storage and remain encrypted during storage. 
It also includes access logging and protection against unauthorized use.

# Features
- User authentication (login/logout)
- TLS (HTTPS) support for secure transmission
- AES encryption for file storage
- File upload and download functionality
- Ownership-based access control
- Logging of file access and download events
- Attempted access logging
- Dashboard with search filter

# Project Structure 
project/
│
├── app.py # Main Flask application
├── templates/ # HTML templates (login, dashboard, upload, etc.)
├── static/ # CSS
├── uploads/ # Encrypted files (per user)
├── logs/ # Access logs and security logs
├── FILE_SYSTEM.sql # SQLite user/file metadata DB
├── certs/ # TLS certificates
└── README.md # This file
