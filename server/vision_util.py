"""
Handles the vision processing functions
"""
import cv2
import numpy as np
import json
from api_keys import GOOGLE_API_KEY
import base64
import requests
import os
import re

def image_from_base64_string(base64_string):
    encoded_data = base64_string
    nparr = np.fromstring(encoded_data.decode('base64'), np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    return img

def get_default_image():
    """Returns a default image."""
    dir_path = os.path.dirname(os.path.realpath(__file__))
    image_filename = os.path.join(dir_path, "images/card_0.png")
    image = cv2.imread(image_filename)
    return image

def get_phone_from_string(my_string):
    """Get the phone number."""
    r = re.search(r'\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})', my_string)
    if not r:
        return ""
    phone = r.group(0)
    return phone

def get_email_from_string(my_string):
    """Get the email address."""
    r = re.search(r'[\w\.-]+@[\w\.-]+', my_string)
    if not r:
        return ""
    email = r.group(0)
    return email

def save_image(image):
    current_path = os.path.dirname(os.path.abspath(__file__))
    path_to_save_to = os.path.join(current_path, "images/recently_saved.png")
    cv2.imwrite(path_to_save_to, image)

def encode_image_as_base64(image):
    retval, buffer = cv2.imencode('.jpg', image)
    image_as_text = base64.b64encode(buffer)
    return image_as_text

def get_text_info_from_image(image):
    """Returns the raw string from the vision API"""
    image_as_text = encode_image_as_base64(image)

    url = "https://vision.googleapis.com/v1/images:annotate"
    data = {
        "requests":[
            {
            "image":{
                "content": image_as_text.decode("utf-8")
                },
                "features":[
                    {
                        "type":"LABEL_DETECTION",
                        "maxResults":1
                    },
                    {
                        "type":"DOCUMENT_TEXT_DETECTION",
                        "maxResults":1
                    }
                ]
            }
        ]
    }

    headers = {
        'Content-Type': "application/json",
        'Cache-Control': "no-cache",
    }

    querystring = {"key": GOOGLE_API_KEY}

    response = requests.post(url, data=json.dumps(data), headers=headers, params=querystring)
    response_json = response.json()
    try:
        ascii_string = str(response_json['responses'][0]['textAnnotations'][0]['description'])
    except:
        ascii_string = "Moin Nadeem MIT"
    return ascii_string

def get_search_string(image):
    """
    Returns the data from the card to be searched in Google.
    Returns of form: google_search_string, raw_string
    """
    
    ascii_string = get_text_info_from_image(image)
    words = ascii_string.split("\n")
    used_words = []
    # remove dashes (-)
    # remove things of length 0

    for word in words:
        if len(word) == 0:
            continue
        if '-' in word:
            continue
        used_words.append(word)

    current_string = " ".join(used_words) + " linkedin"
    request_string = "https://www.google.com/search?q={}".format(current_string.replace(" ", "%20"))
    current_output = requests.get(request_string).text
    while len(used_words) > 2 and current_output.find("did not match any documents.") >= 0:
        # remove an element off the used_words list
        used_words.pop()
        current_string = " ".join(used_words) + " linkedin"
        request_string = "https://www.google.com/search?q={}".format(current_string.replace(" ", "%20"))
        current_output = requests.get(request_string).text

    return str(current_string), str(ascii_string)

def get_cropped_and_rectified_image(image):
    edges = cv2.Canny(image,100,200,apertureSize=3)
    lines = cv2.HoughLines(edges,1, np.pi/180,100)

    # find intersections in x,y space
    intersections = []
    # iterate over all possible intersections
    for i in range(len(lines)-1):
        for j in range(i, len(lines)):
            line1 = lines[i]
            line2 = lines[j]
            rho1, theta1 = line1[0]
            rho2, theta2 = line2[0]
            
            theta_diff = abs(theta1 - theta2) % 3.14
            theta_thresh = .1
            if abs(theta_diff - 1.5707) < theta_thresh:
                x = int(rho1*np.cos(theta1) + rho2*np.cos(theta2))
                y = int(rho1*np.sin(theta1) + rho2*np.sin(theta2))
                intersections.append([x,y])

    # do non-maximal suppression on intersections
    filtered_intersection_image = image.copy()
    filtered_intersections = []
    # sort by x and then y
    sorted_intersections = sorted(intersections)

    # dictionary to maybe use key, value pairs later
    used_points = {}
    for i in range(len(intersections)-1):
        for j in range(i, len(intersections)):
            x1, y1 = intersections[i]
            x2, y2 = intersections[j]
            x_diff = abs(x1-x2)
            y_diff = abs(y1-y2)
            thresh = 20
            if x_diff < thresh and y_diff < thresh:
                if (x1,y1) not in used_points:
                    filtered_intersections.append([x1,y1])
                used_points[(x2,y2)] = True

    
    # find the 4 corners
    final_corner_image = image.copy()
    height, width = image.shape[:2]
    tl, tr, bl, br = None, None, None, None
    tl_min, tr_min, bl_min, br_min = None, None, None, None
    for x,y in filtered_intersections:
        tl_dist = (x-0)**2 + (y-0)**2
        tr_dist = (x-width)**2 + (y-0)**2
        bl_dist = (x-0)**2 + (y-height)**2
        br_dist = (x-width)**2 + (y-height)**2
        
        # top left
        if tl_min is None or tl_dist < tl_min:
            tl = (x,y)
            tl_min = tl_dist
        
        # top right
        if tr_min is None or tr_dist < tr_min:
            tr = (x,y)
            tr_min = tr_dist
            
        # bottom left
        if bl_min is None or bl_dist < bl_min:
            bl = (x,y)
            bl_min = bl_dist
            
        # bottom right
        if br_min is None or br_dist < br_min:
            br = (x,y)
            br_min = br_dist
            
    # final points
    final_points = [tl, tr, bl, br]
    for point in final_points:
        cv2.circle(final_corner_image, point, 10, (0,0,255), -1)

    # card dimensions: 3.5 in x 2 in
    pixel_width = 500
    pixel_height = int(pixel_width*(2.0/3.5))

    # compute the homography
    pts_dst = [
        [0,0],
        [pixel_width,0],
        [0,pixel_height],
        [pixel_width,pixel_height]
    ]
    h, status = cv2.findHomography(np.array(final_points), np.array(pts_dst))

    im_dst = cv2.warpPerspective(image, h, (pixel_width, pixel_height))

    return im_dst