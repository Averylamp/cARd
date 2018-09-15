from flask import Flask, request
from vision import get_cropped_and_rectified_image
app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, World!'

@app.route('/handle_image', methods=['POST', 'GET'])
def handle_image():
    return 'Handle Image.'

    # example code below
    # ------------------
    # error = None
    # if request.method == 'POST':
    #     if valid_login(request.form['username'],
    #                    request.form['password']):
    #         return log_the_user_in(request.form['username'])
    #     else:
    #         error = 'Invalid username/password'

if __name__ == '__main__':
    # set debug and threaded modes
    app.run(debug=True, threaded=True)