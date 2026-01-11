@app.route('/update_repo', methods=['POST'])
def update_repo():
    if not GITHUB_PAT:
        return jsonify({'error': 'GitHub PAT not configured'}), 500

    # Set repo_dir to parent directory of app.py
    repo_dir = os.path.abspath(os.path.join(script_dir, '..'))

    repo_url = 'https://github.com/padge81/edid-emulator-webapp.git'
    auth_repo_url = repo_url.replace('https://', f'https://{GITHUB_PAT}@')

    # Run git pull
    cmd = f'git -C "{repo_dir}" pull {auth_repo_url}'
    stdout, stderr = run_command(cmd)
    if stderr:
        return jsonify({'error': stderr}), 500
    return jsonify({'message': 'Repository updated successfully.', 'output': stdout})