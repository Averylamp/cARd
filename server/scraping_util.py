from MAEZ.scrapers.Google import GoogleScraper
from MAEZ.scrapers.LinkedIn import LinkedInScraper

@memoize
def get_person(name, phone_number, email):
    g = GoogleScraper()
    linkedin_urls = g.scrape_by_name(user=name)
    print(linkedin_urls)
    name_no_linkedin = name.split("linkedin")[0]
    all_urls = g.scrape_by_name(user=name_no_linkedin)

    l = LinkedInScraper()
    l.sign_in()
    l.navigate(linkedin_urls['linkedin'][0])
    l.driver.save_screenshot("test")
    p = l.extract_profile()

    response = {}
    response['name'] = "{} {}".format(p.first, p.last)
    response['education_list'] = p.educationalHistory
    response['currentEducation'] = p.education
    response['positions_list'] = p.positions
    s = "".join(["{}, ".format(pos['employer']) for pos in p.positions])
    response['position_str'] = "Previously worked at {}.".format(s)
    response['description'] = p.headline
    response['links'] = all_urls
    response['phone_number'] = phone_number
    response['email'] = email
    return response
