# app/init_db.py
import os
import time
import psycopg2
from psycopg2 import OperationalError
from dotenv import load_dotenv
import sys
sys.path.append('/app')
from app import create_app, db
from app.models import User, Task

load_dotenv('/app/.env')

def wait_for_db():
    db_config = {
        'dbname': os.getenv('DB_NAME'),
        'user': os.getenv('DB_USER'),
        'password': os.getenv('DB_PASS'),
        'host': os.getenv('DB_HOST'),
        'port': os.getenv('DB_PORT')
    }
    print(f"Connecting to: {db_config}")
    for _ in range(30):
        try:
            conn = psycopg2.connect(**db_config)
            conn.close()
            print("Database is ready!")
            return True
        except OperationalError as e:
            print(f"Waiting for database... Error: {e}")
            time.sleep(2)
    return False

def init_db():
    if not wait_for_db():
        print("Could not connect to database. Exiting...")
        exit(1)
    app = create_app()
    with app.app_context():
        db.create_all()
        print("Database initialized!")

if __name__ == "__main__":
    init_db()