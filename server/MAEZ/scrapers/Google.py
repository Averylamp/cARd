from MAEZ.scrapers.BaseScraper import *
from selenium.webdriver.common.keys import Keys
import time
import re

class GoogleScraper(BaseScraper):
    def __init__(self):
        super(GoogleScraper, self).__init__()
        self.navigate("https://google.com")
        
    ## Returns dictionary of domain names and list of urls
    def scrape_by_name(self, user = "Moin Nadeem"):
        self.navigate("https://google.com")
        input_elem = self.driver.find_elements_by_tag_name("input")
        search_elem = None
        for elem in input_elem:
            if elem.get_attribute("title") == "Search":
                search_elem = elem
        if search_elem is None:
            print("Failed to find search bar")
            return dict()
        search_elem.send_keys(user + " ")
        time.sleep(0.5)
        search_elem.send_keys(Keys.DOWN)
        time.sleep(0.5)
        search_elem.send_keys(Keys.UP)
        time.sleep(0.25)
        search_elem.send_keys(Keys.ENTER)
        
        suggestions = self.driver.find_elements_by_class_name("sbqs_c")
        suggestion_text = []
        for suggestion in suggestions:
            suggestion_text.append(suggestion.text.replace(user.lower(), ""))
        print(suggestion_text)
        
        results = dict()
        urls_to_explore = dict()
        urls = ["linkedin", "facebook","arxiv", "twitter", "github", "devpost", "kaggle", "medium"]
        domains = [".com", ".me"]
        def search_page(urls_to_explore, urls):
            found_items = False
            for r in self.driver.find_elements_by_xpath("//div[@class='rc']//h3//a"):
                for url in urls:
                    if url in r.text.lower():
                        found_items = True
                        if url in urls_to_explore:
                            urls_to_explore[url].append(r.get_attribute("href"))
                        else:
                            urls_to_explore[url] = []
                            urls_to_explore[url].append(r.get_attribute("href"))
                        print("Found a {}".format(url))
                        print("URL: {}".format(r.get_attribute("href")))
                for domain in domains:
                    if (user.replace(" ", "") + domain).lower() in r.get_attribute("href").lower():
                        if "personal" in urls_to_explore:
                            urls_to_explore["personal"].add(r.get_attribute("href"))
                        else:
                            urls_to_explore["personal"] = [] 
                            urls_to_explore["personal"].append(r.get_attribute("href"))
                        print("Found a personal")
                        print("URL: {}".format(r.get_attribute("href")))
            return found_items

        def next_page():
            next_button = self.driver.find_elements_by_id("pnnext")
            if len(next_button) == 1:
                next_button[0].click()
                return True
            return False
        while search_page(urls_to_explore, urls):
            if next_page():
                continue
            else:
                print("Couldn't find next button")
                break
        self.navigate("http://google.com")
        input_elem = self.driver.find_elements_by_tag_name("input")
        search_elem = None
        for elem in input_elem:
            if elem.get_attribute("title") == "Search":
                search_elem = elem
        search_elem.send_keys(user + " filetype:pdf")
        time.sleep(0.25)
        search_elem.send_keys(Keys.ENTER)
        for r in self.driver.find_elements_by_xpath("//div[@class='rc']//h3//a"):
            if "resume" in r.text.lower():
                if "resume" in urls_to_explore:
                        urls_to_explore["resume"].add(r.get_attribute("href"))
                else:
                    urls_to_explore["resume"] = set()
                    urls_to_explore["resume"].add(r.get_attribute("href"))
        print("URLs to explore:", urls_to_explore)
        return urls_to_explore
        
