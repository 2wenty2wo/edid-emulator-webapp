from flask import Flask, request, jsonify, render_template
import subprocess
import os
import sys
import signal
import re

app = Flask(__name__)

# Directory setup
script_dir = os.path.dirname(os.path.abspath(__file__))
save_dir = os.path.join(script_dir, 'edid_Files')
if not os.path.exists(save_dir):
    os.makedirs(save_dir)

# Path to edid-rw
edid_rw_path = os.path.join(script_dir, 'edid-rw', 'edid-rw')
edid_decode_path = os.path.join(script_dir, 'edid-decode')

# Your GitHub PAT
GITHUB_PAT = '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'

# Hardcoded version
VERSION = "1.0.10"

def run_command(command, cwd=None):
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True, cwd=cwd)
        return result.stdout
    except Exception as e:
        print(f"Error running command: {e}")
        return None

def run_edid_rw(read=False, write=False, port=2, filename=None):
    if read:
        if write:
            command = f"{edid_rw_path} {port} < {filename}"
        else:
            command = f"{edid_rw_path} {port} | {edid_decode_path}"
    elif write:
        command = f"{edid_rw_path} -w {port} < {filename}"
    else:
        print("Invalid command")
        return None
    return run_command(command)

def run_edid_decode():
    command = f"{edid_rw_path} {port} | {edid_decode_path}"
    return run_command(command)

@app.route('/edid', methods=['GET'])
def get_edid():
    return jsonify({'message': 'EDID Retrieval'})

@app.route('/edid/read', methods=['POST'])
def read_edid():
    port = int(request.get_json()['port'])
    filename = request.get_json()['filename']
    result = run_edid_rw(read=True, port=port, filename=filename)
    return jsonify({'message': result})

@app.route('/edid/write', methods=['POST'])
def write_edid():
    port = int(request.get_json()['port'])
    filename = request.get_json()['filename']
    result = run_edid_rw(read=False, write=True, port=port, filename=filename)
    return jsonify({'message': result})

@app.route('/edid/decode', methods=['POST'])
def decode_edid():
    result = run_edid_decode()
    return jsonify({'message': result})

if __name__ == "__main__":
    app.run(debug=True)