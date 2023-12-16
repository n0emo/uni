import hashlib
import os
import json

PASS_FILE = "data/passwords.json"
LOGINS_FILE = "data/logins.json"

logins = []
passwords = []


def pass_hash(login: str, pass_: str) -> str:
    return hashlib.sha256((pass_ + login).encode()).hexdigest()

def create_pass_file_if_dont_exists():
    if os.path.exists(PASS_FILE):
        return
    
    with open(PASS_FILE, 'w') as file:
        file.write("{}")

def add_pass(login: str, pass_: str) -> None:
    create_pass_file_if_dont_exists()

    with open(PASS_FILE, 'r') as file:
        passwords = json.load(file)

    passwords[login] = pass_hash(login, pass_)

    with open(PASS_FILE, 'w') as file:
        json.dump(passwords, file)

def check_pass(login: str, pass_: str) -> bool:
    hash_ = pass_hash(login, pass_)

    with open(PASS_FILE, 'r') as file:
        passwords = json.load(file)
    
    return login in passwords and passwords[login] == hash_

def login_exists(login: str):
    with open(PASS_FILE, 'r') as file:
        passwords = json.load(file)

    return login in passwords



