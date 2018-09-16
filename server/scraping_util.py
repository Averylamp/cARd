import base64
import re
import requests

from MAEZ.scrapers.Google import GoogleScraper
from MAEZ.scrapers.LinkedIn import LinkedInScraper

memo = {}

def get_person(name, phone_number, email):
    key = "{}{}{}".format(name, phone_number, email)
    if key in memo:
        return memo[key]

    g = GoogleScraper()
    all_urls = g.scrape_by_name(user=name)

    l = LinkedInScraper()
    l.sign_in()
    print("URLs:", all_urls)
    print("LinkedIn URLs:", all_urls['linkedin'])

    if 'linkedin' in all_urls:
        l.navigate(all_urls['linkedin'][0])
    else:
        raise Exception("LinkedIn URLs not found!")

    l.driver.save_screenshot("test")
    p = l.extract_profile()

    response = {}

    if p.profile_picture is not None:
        picture = get_as_base64(p.profile_picture)
        response['profile_picture'] = picture.decode("utf-8")
    else:
        picture = None
        response['profile_picture'] = picture

    response['name'] = "{} {}".format(p.first, p.last)
    response['education_list'] = p.educationalHistory
    response['currentEducation'] = p.education
    response['positions_list'] = p.positions
    s = "".join(["{}, ".format(pos['employer']) for pos in p.positions])
    response['position_str'] = "Previously worked at {}.".format(s)
    response['description'] = p.headline
    response['links'] = all_urls
    response['phone_number'] = re.sub("[^0-9]", "", str(phone_number))
    response['email'] = email

    memo[key] = response
    return response

def get_as_base64(url):
    return base64.b64encode(requests.get(url).content)
