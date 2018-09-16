from MAEZ.scrapers.BaseScraper import *
from selenium.webdriver.common.keys import Keys
import time
import re

def time_divide(string):
    duration = re.search("\((.*?)\)", string)

    if duration != None:
        duration = duration.group(0)
        string = string.replace(duration, "").strip()
    else:
        duration = "()"

    times = string.split("-")
    try:
        return (times[0].strip(), times[1].strip(), duration[1:-1])
    except Exception as e:
        return None, None, None


class LinkedInScraper(BaseScraper):
    def __init__(self):
        super(LinkedInScraper, self).__init__()

    def sign_in(self):
        self.navigate("http://linkedin.com")
        input_elem = self.driver.find_element_by_id("login-email")
        time.sleep(0.4)
        input_elem.send_keys("juanmae@mit.edu")
        input_elem = self.driver.find_element_by_id("login-password")
        input_elem.send_keys("juanmae1234")
        time.sleep(1.4)
        input_elem.send_keys(Keys.ENTER)

    def extract_profile(self):
        time.sleep(0.4)
        name = self.driver.find_element_by_class_name("pv-top-card-section__name").text 
        first, last = name.split(" ")
        profile = LinkedInProfile(first, last)

        headline = self.driver.find_element_by_class_name("pv-top-card-section__headline").text
        profile.set_headline(headline)

        try:
            picture = self.driver.find_element_by_class_name("pv-top-card-section__photo").get_attribute("style")
            picture = re.search('background-image: ?url\("([^"]*)"\);', picture).group(1)
            profile.set_profile_picture(picture)
        except Exception as e:
            profile.profile_picture = None

        locality = self.driver.find_elements_by_class_name("pv-top-card-section__location")
        if len(locality) > 0:
            profile.set_locality(locality[0].text)
        
        conn_num = self.driver.find_element_by_class_name("pv-top-card-v2-section__entity-name").text
        conn_num = conn_num.split(" connections")[0]
        profile.set_connections(conn_num)

        employer = self.driver.find_element_by_class_name("pv-top-card-v2-section__company-name").text
        profile.set_current_employer(employer)

        education = self.driver.find_element_by_class_name("pv-top-card-v2-section__school-name").text
        profile.set_education(education)

        work_history = self.driver.find_elements_by_class_name("pv-position-entity")

        for job in work_history:
            title = job.find_element_by_tag_name("h3").text.strip()
            try:
                company = job.find_element_by_class_name("pv-entity__secondary-title").text.strip()
            except Exception as e:
                company = "Multiple Positions" 
            times = job.find_element_by_class_name("pv-entity__date-range").find_elements_by_tag_name("span")[1].text.strip()
            from_date, to_date, duration = time_divide(times)
            location = ""
            if len(job.find_elements_by_class_name("pv-entity__location")) > 0:
                location = job.find_element_by_class_name("pv-entity__location").find_elements_by_tag_name("span")[1].text.strip()
            try:
                description = job.find_element_by_class_name("pv-entity__description").text
            except:
                description = None
            profile.createPosition(title, company, from_date, to_date, location, description)

        
        educational_history = self.driver.find_elements_by_class_name("pv-entity__degree-info")
        for education in educational_history:
            school_name = education.find_element_by_class_name("pv-entity__school-name").text.strip()
            degree = None

            try:
                degree = education.find_element_by_class_name("pv-entity__degree-name").find_elements_by_tag_name("span")[1].text.strip()
                times = education.find_element_by_class_name("pv-entity__dates").text.strip()
                from_date, to_date = times.split("-")
                from_date = from_date.strip()
                to_date = to_date.strip()
            except:
                from_date, to_date = (None, None)

            try:
                field_of_study = education.find_element_by_class_name("pv-entity__fos").find_elements_by_tag_name("span")[1].text.strip()
            except:
                field_of_study = None

            profile.createEducation(school_name, degree, field_of_study, from_date, to_date) 
        return profile


class LinkedInProfile(BaseProfile):
    def __init__(self, first, last):
        super(LinkedInProfile, self).__init__(first, last)
        self.positions = []
        self.educationalHistory = []
        self.connections = None
        self.headline = None
        self.industry = None
        self.profile_picture = None
        
    def __repr__(self):
        result = ""
        if self.first and self.last and self.headline and self.connections is not None:
            result += "{} {}, {}, ({}) connections".format(self.first, self.last, self.headline, self.connections) + "\n"
        elif self.headline:
            result += "{} {}, {},".format(self.first, self.last, self.headline) + "\n"
        else:
            result += "{} {},".format(self.first, self.last) + "\n"
            
        if self.locality is not None:
            result += self.locality + "\n"
        if self.industry is not None:
            result += self.industry + "\n"
        for education in self.educationalHistory:
            result += "{}\n".format(education)
        for position in self.positions:
            result += "{}\n".format(position)
        return result
    
    def set_profile_picture(self, url):
        self.profile_picture = url

    def set_headline(self, headline):
        self.headline = headline

    def set_locality(self, locality):
        self.locality = locality

    def set_industry(self, industry):
        self.industry = industry

    def set_connections(self, conn_num):
        self.connections_number = conn_num

    def set_current_employer(self, employer):
        self.current_employer = employer

    def set_education(self, edu):
        self.education = edu

    def createPosition(self, title, employer, start_date, end_date, location, description):
        """
            title: position title, e.g. "Software Engineering Intern
            employer: employer name, e.g. "Google"
            start_date: start date of employement
            end_date: end date of employment
            location: location of employment
            descrption: user's self-provided description of employment
        """
        position = {}
        position['title'] = title
        position['employer'] = employer
        position['start_date'] = start_date
        position['end_date'] = end_date
        position['location'] = location
        position['description'] = description
        self.positions.append(position)

    def createEducation(self, school_name, degree_name, field_of_study, begin_date, end_date):
        """
        school_name: name of school attended
        degree_name: degree being awarded, Bachelors / Masters, etc.
        field_of_study: field being awarded, e.g. Computer Science
        begin_date: when the user began their education
        end_date: when the user ended their education 
        """
        education = {}
        education['school_name'] = school_name
        education['degree_name'] = degree_name
        education['field_of_study'] = field_of_study
        education['begin_date'] = begin_date
        education['end_date'] = end_date
        self.educationalHistory.append(education)
