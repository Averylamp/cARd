from flask import Flask, jsonify
from multiprocessing import Queue, Process, cpu_count
from selenium.webdriver.common.keys import Keys
from LinkedIn import *
from BaseScraper import *
from Google import *

app = Flask(__name__)

## INITIALIZATION ##

def initialize():
    for i in range(cpu_count()):
        deployLinkedIn()
        print("Deploying LinkedInScraper {}".format(i + 1))

linkedinQueue = Queue()
linkedinWorkers = []
def deployLinkedIn():
    global linkedinWorkers
    linkedInScraper = LinkedInScraper()
    linkedInScraper.sign_in()
    linkedinWorkers.append(linkedInScraper)




## PUBLIC APIS ##

@app.route("/linkedin/user/<string:user>")
def linkedIn(user):
    print(user)
    return jsonify([user])

if __name__=="__main__":
    initialize()
    app.run(threaded=True, debug=True,host='0.0.0.0', port=5000)
