from flask import Flask, request
from vision_util import *
import cv2
import os
app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, World!'

def get_default_value():
    """Default use of the vision_util functions"""
    dir_path = os.path.dirname(os.path.realpath(__file__))
    image_filename = os.path.join(dir_path, "images/card_0.png")
    image = cv2.imread(image_filename)
    processed_image = get_cropped_and_rectified_image(image)
    search_string = get_search_string(processed_image)
    return search_string

@app.route('/handle_image', methods=['POST', 'GET'])
def handle_image():
    # convert to the image format

    # if a GET request, return a default value
    if request.method == 'GET':
        return get_default_value()
    # this is what we are want
    elif request.method == 'POST':
        pass
    
    return "hi"

if __name__ == '__main__':
    # set debug and threaded modes
    app.run(debug=True, threaded=True)