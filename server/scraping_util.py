import base64
import re
import requests

from MAEZ.scrapers.Google import GoogleScraper
from MAEZ.scrapers.LinkedIn import LinkedInScraper

def get_person(name, phone_number, email):
    g = GoogleScraper()
    all_urls = g.scrape_by_name(user=name)

    l = LinkedInScraper()
    l.sign_in()
    l.navigate(all_urls['linkedin'][0])
    l.driver.save_screenshot("test")
    p = l.extract_profile()

    if p.profile_picture is not None:
        picture = get_as_base64(p.profile_picture)
    response = {}
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
    response['profile_picture'] = picture
    return response

def get_as_base64(url):
    return base64.b64encode(requests.get(url).content)
