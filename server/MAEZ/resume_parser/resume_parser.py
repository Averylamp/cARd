# parses pdfs

import PyPDF2
pdfFileObj = open('test_resumes/Resume_EthanWeber_Sep_2018.pdf','rb')     #'rb' for read binary mode
pdfReader = PyPDF2.PdfFileReader(pdfFileObj)
# only work for single page resume right now
assert pdfReader.numPages == 1
# 0 is the first page
pageObj = pdfReader.getPage(0)

original_text = pageObj.extractText()
# convert the text to ascii and remove characters that aren't known
page_text = original_text.encode('ascii',errors='ignore').decode('utf8')

filtered = page_text.replace('\n','')
filtered = filtered.replace(',','')

keywords = filtered.split()

# remove beginning or ending punctuation if it exists
punctuation = [".", "!", "?"]
for index in range(len(keywords)):

    if len(keywords[index]) == 0:
        continue

    # check ending punctuation
    if keywords[index][-1] in punctuation:
        keywords[index] = keywords[index][:-1]

    if len(keywords[index]) == 0:
        continue
    # check beginning punctuation
    if keywords[index][0] in punctuation:
        keywords[index] = keywords[index][1:]

def get_potential_urls(keywords):
    chars_to_strip = ["(", ")", "@"]
    potential_urls = []
    for keyword in keywords:
        if '.' in keyword:
            potential_url = keyword
            # strip what is not needed
            for value in chars_to_strip:
                potential_url = potential_url.replace(value, '')
            potential_urls.append(potential_url)
    return potential_urls

import requests
import eventlet
eventlet.monkey_patch()
def get_valid_urls(potential_urls):
    valid_urls = []
    for potential_url in potential_urls:
        url_used = potential_url
        if "http" not in potential_url:
            url_used = "{}{}".format("http://", potential_url)
        try:
            requests.get(url_used, verify=False)
        except:
            continue
        # if it gets to this point, it had a valid request
        valid_urls.append(url_used)
    return valid_urls


potential_urls = get_potential_urls(keywords)
print("Potential URLS: {}".format(potential_urls))
valid_urls = get_valid_urls(potential_urls)
print("Valid URLS: {}".format(valid_urls))