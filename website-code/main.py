from flask import Flask, render_template
import sqlite3, hashlib, os
from werkzeug.utils import secure_filename
import random
import base64
import string

def randomString(stringLength=8):
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for i in range(stringLength))

app = Flask(__name__)

@app.route("/")
def root():
    rendered_output = render_template('home.html')
    return rendered_output


if __name__ == '__main__':
    app.run(host="0.0.0.0",debug=True)
