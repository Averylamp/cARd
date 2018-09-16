from flask import Flask, request, jsonify
from vision_util import *
from scraping_util import get_person
import cv2
import os
app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, World!'

@app.route('/sample/<name>')
def sample(name):
    with open('images/{}.txt'.format(name), 'r') as myfile:
        data=myfile.read().replace('\n', '')
    my_dict = json.loads(data)
    return jsonify(my_dict)

@app.route('/handle_image', methods=['POST', 'GET'])
def handle_image():
    # convert to the image format

    return_template = dict(
        cropped_image="",
        information=""
    )

    # if a GET request, return a default value
    if request.method == 'GET':
        image = get_default_image()
    # this is what we are want
    elif request.method == 'POST':
        my_data = json.loads(request.data)
        image_str = str(my_data['image_data'])
        # convert from base64 to image
        image = image_from_base64_string(image_str)

    google_search_string, raw_string = get_search_string(image)
    phone = str(get_phone_from_string(raw_string))
    email = str(get_email_from_string(raw_string))

    person_data = get_person(google_search_string, phone, email)
    return_template['information'] = person_data

    processed_image = get_cropped_and_rectified_image(image)
    # convert to base64to return
    processed_image_string = encode_image_as_base64(processed_image)
    return_template['cropped_image'] = processed_image_string.decode("utf-8")
    
    return jsonify(return_template)

if __name__ == '__main__':
    # set debug and threaded modes
    app.run(host="0.0.0.0", threaded=True)
