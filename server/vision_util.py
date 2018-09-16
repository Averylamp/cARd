"""
Handles the vision processing functions
"""
import cv2
import numpy as np
import json
from api_keys import GOOGLE_API_KEY
import base64
import requests

def save_image(image):
    cv2.imwrite("recently_saved.png", image)


def get_search_string(image):
    """Returns the data from the card to be searched in Google."""
    retval, buffer = cv2.imencode('.jpg', image)
    image_as_text = base64.b64encode(buffer)

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
    ascii_string = str(response_json['responses'][0]['textAnnotations'][0]['description'])
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

    return current_string

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