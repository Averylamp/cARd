from selenium import webdriver

class BaseScraper(object):
    def __init__(self):
       self.driver = webdriver.Chrome('./chromedriver') 
    
    def navigate(self, url):
        self.driver.get(url)

class BaseProfile(object):
    def __init__(self, first, last):
        self.first = first
        self.last = last
